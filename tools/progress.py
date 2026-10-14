#!/usr/bin/env python3
"""Write site/progress.json from the symbol list and the notes."""

from __future__ import annotations

import json
import re
import subprocess
from datetime import datetime, timedelta, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "NOTES.md"
CONFIG = ROOT / "config" / "arm9"
SITE = ROOT / "site" / "progress.json"
REPO = "https://github.com/baker339/urbz-re"

SYMBOL = re.compile(
    r"^(?P<name>\S+)\s+kind:(?P<kind>\w+)(?:\([^)]*\))?\s+addr:0x(?P<addr>[0-9a-fA-F]+)"
)
NOTE_ROW = re.compile(
    r"^\| `(?P<addr>[0-9a-fA-F]+)` \| `(?P<name>[A-Za-z_][A-Za-z0-9_]*)` \| (?P<what>.*) \|$"
)
MODULE_SECTION = re.compile(
    r"^(?P<name>\S+)\s+start:0x(?P<start>[0-9a-fA-F]+)\s+end:0x(?P<end>[0-9a-fA-F]+)\s+kind:(?P<kind>\w+)"
)
FILE_SECTION = re.compile(
    r"^(?P<name>\S+)\s+start:0x(?P<start>[0-9a-fA-F]+)\s+end:0x(?P<end>[0-9a-fA-F]+)\s*$"
)


def git_text(rev: str, path: str) -> str:
    result = subprocess.run(
        ["git", "show", f"{rev}:{path}"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def symbol_files(rev: str | None) -> list[str]:
    if rev is None:
        return [path.read_text() for path in sorted(CONFIG.rglob("symbols.txt"))]
    listing = subprocess.run(
        ["git", "ls-tree", "-r", "--name-only", rev, "config/arm9"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    paths = [line for line in listing.stdout.splitlines() if line.endswith("symbols.txt")]
    return [git_text(rev, path) for path in paths]


def count_named(rev: str | None) -> int:
    total = 0
    for text in symbol_files(rev):
        for line in text.splitlines():
            match = SYMBOL.match(line)
            if not match or match.group("kind") != "function":
                continue
            name = match.group("name")
            if name.startswith("func_") or name.endswith("_unk"):
                continue
            total += 1
    return total


def first_commit() -> tuple[str, datetime] | None:
    result = subprocess.run(
        ["git", "log", "--reverse", "--format=%H%x09%aI"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    line = result.stdout.splitlines()[0] if result.stdout else ""
    if not line:
        return None
    rev, stamp = line.split("\t", 1)
    return rev, datetime.fromisoformat(stamp)


def estimate(named: int, functions: int) -> dict[str, object] | None:
    """Date every function has a name, at the pace since the first commit."""
    opened = first_commit()
    if opened is None or functions <= named:
        return None
    rev, started = opened
    baseline = count_named(rev)
    gained = named - baseline
    elapsed = datetime.now(timezone.utc) - started
    if gained <= 0 or elapsed.total_seconds() <= 0:
        return None
    remaining = functions - named
    seconds_left = remaining * elapsed.total_seconds() / gained
    finish = datetime.now(timezone.utc) + timedelta(seconds=seconds_left)
    days = max(1, round(seconds_left / 86400))
    return {
        "finish": f"{finish.strftime('%B')} {finish.day}, {finish.year}",
        "days": days,
        "gained": gained,
        "remaining": remaining,
    }


def commit() -> str:
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--short", "HEAD"],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError:
        return ""
    return result.stdout.strip()


def note_rows() -> dict[str, dict[str, str]]:
    rows: dict[str, dict[str, str]] = {}
    in_names = False
    for line in NOTES.read_text().splitlines():
        if line.startswith("## "):
            in_names = line == "## Names"
            continue
        if not in_names:
            continue
        match = NOTE_ROW.match(line)
        if not match:
            continue
        rows[match.group("name")] = {
            "address": match.group("addr").lower(),
            "description": match.group("what").replace("`", ""),
        }
    return rows


def functions(notes: dict[str, dict[str, str]]) -> tuple[int, list[dict[str, str]]]:
    named: list[dict[str, str]] = []
    total = 0
    for path in sorted(CONFIG.rglob("symbols.txt")):
        module = "main" if path.parent == CONFIG else path.parent.name
        for line in path.read_text().splitlines():
            match = SYMBOL.match(line)
            if not match or match.group("kind") != "function":
                continue
            total += 1
            name = match.group("name")
            if name.startswith("func_") or name.endswith("_unk"):
                continue
            address = match.group("addr").lower()
            note = notes.get(name, {})
            named.append(
                {
                    "address": address,
                    "name": name,
                    "module": module,
                    "description": note.get("description", ""),
                    "notes_address": note.get("address", address),
                }
            )
    named.sort(key=lambda row: int(row["address"], 16))
    return total, named


def code_bytes(path: Path) -> tuple[int, int]:
    total = 0
    matched = 0
    code_sections: set[str] = set()
    current: dict[str, object] | None = None
    files: list[dict[str, object]] = []

    def finish() -> None:
        if current is not None:
            files.append(current)

    for raw in path.read_text().splitlines():
        if not raw.strip():
            continue
        if raw.startswith("    "):
            body = raw.strip()
            if current is None:
                match = MODULE_SECTION.match(body)
                if match and match.group("kind") == "code":
                    code_sections.add(match.group("name"))
                    total += int(match.group("end"), 16) - int(match.group("start"), 16)
                continue
            if body == "complete":
                current["complete"] = True
                continue
            match = FILE_SECTION.match(body)
            if match and match.group("name") in code_sections:
                size = int(match.group("end"), 16) - int(match.group("start"), 16)
                current["code"] = int(current["code"]) + size
            continue
        if raw.endswith(":"):
            finish()
            current = {"complete": False, "code": 0}
    finish()
    matched = sum(int(item["code"]) for item in files if item["complete"])
    return total, matched


def main() -> None:
    notes = note_rows()
    total_functions, named = functions(notes)
    code = 0
    matched = 0
    for path in sorted(CONFIG.rglob("delinks.txt")):
        part_code, part_matched = code_bytes(path)
        code += part_code
        matched += part_matched
    payload = {
        "commit": commit(),
        "repo": REPO,
        "functions": total_functions,
        "named": len(named),
        "code_bytes": code,
        "matched_bytes": matched,
        "named_functions": named,
        "estimate": estimate(len(named), total_functions),
        "open": [
            {
                "title": "CodeWarrior version",
                "detail": "Matching C waits on the compiler this game was built with.",
                "href": f"{REPO}/issues/1",
            },
            {
                "title": "ARM7",
                "detail": "The helper CPU is not in the split yet.",
                "href": f"{REPO}/blob/main/CONTRIBUTING.md#arm7",
            },
            {
                "title": "Dialogue, missions, and menus",
                "detail": "None of these systems are mapped.",
                "href": f"{REPO}/blob/main/CONTRIBUTING.md#still-open",
            },
            {
                "title": "SoundData.rom",
                "detail": "The second archive on the cartridge is unread.",
                "href": f"{REPO}/blob/main/CONTRIBUTING.md#still-open",
            },
        ],
    }
    SITE.parent.mkdir(parents=True, exist_ok=True)
    SITE.write_text(json.dumps(payload, indent=2) + "\n")
    print(
        f"{payload['named']} named / {payload['functions']} functions, "
        f"{payload['matched_bytes']} / {payload['code_bytes']} bytes matched"
    )
    estimate_row = payload["estimate"]
    if estimate_row:
        print(f"naming finishes around {estimate_row['finish']} ({estimate_row['days']} days)")


if __name__ == "__main__":
    main()
