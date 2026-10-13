#!/usr/bin/env python3
"""Rename dsd symbols using the address table in NOTES.md.

dsd stores the ITCM and DTCM copies at their runtime addresses. The notes
use the address in arm9.bin. A note in that copied range is applied to the
runtime symbol.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "NOTES.md"
CONFIG = ROOT / "config" / "arm9"
EXTRACT = ROOT / "extract" / "arm9"

ARM9_BASE = 0x02000000
ROW = re.compile(
    r"^\| `(?P<addr>[0-9a-fA-F]+)` \| `(?P<name>[A-Za-z_][A-Za-z0-9_]*)` \| "
)
SYMBOL = re.compile(
    r"^(?P<name>\S+)\s+kind:(?P<kind>\w+)(?:\([^)]*\))?\s+addr:0x(?P<addr>[0-9a-fA-F]+)"
)


def autoload_ranges() -> list[tuple[int, int, int]]:
    """File-address range to runtime base, for each copied block."""
    main_size = (EXTRACT / "arm9.bin").stat().st_size
    itcm_size = (EXTRACT / "itcm.bin").stat().st_size
    dtcm_size = (EXTRACT / "dtcm.bin").stat().st_size
    itcm_base = int(re.search(r"base_address:\s*(\d+)", (EXTRACT / "itcm.yaml").read_text()).group(1))
    dtcm_base = int(re.search(r"base_address:\s*(\d+)", (EXTRACT / "dtcm.yaml").read_text()).group(1))
    itcm_file = ARM9_BASE + main_size
    dtcm_file = itcm_file + itcm_size
    return [
        (itcm_file, itcm_file + itcm_size, itcm_base),
        (dtcm_file, dtcm_file + dtcm_size, dtcm_base),
    ]


def note_names() -> list[tuple[int, str]]:
    rows = []
    in_table = False
    for line in NOTES.read_text().splitlines():
        if line.startswith("## "):
            in_table = line == "## Names"
            continue
        if not in_table:
            continue
        match = ROW.match(line)
        if match:
            rows.append((int(match.group("addr"), 16), match.group("name")))
    if not rows:
        raise SystemExit("no names found in NOTES.md")
    return rows


def runtime_address(addr: int, ranges: list[tuple[int, int, int]]) -> int:
    for start, end, base in ranges:
        if start <= addr < end:
            return base + (addr - start)
    return addr


def load_functions() -> tuple[list[tuple[Path, list[str]]], dict[int, tuple[int, int]]]:
    files: list[tuple[Path, list[str]]] = []
    by_addr: dict[int, tuple[int, int]] = {}
    for path in sorted(CONFIG.rglob("symbols.txt")):
        lines = path.read_text().splitlines()
        index = len(files)
        files.append((path, lines))
        for line_no, line in enumerate(lines):
            match = SYMBOL.match(line)
            if match and match.group("kind") == "function":
                by_addr[int(match.group("addr"), 16)] = (index, line_no)
    return files, by_addr


def main() -> int:
    ranges = autoload_ranges()
    files, by_addr = load_functions()
    renamed = 0
    missing = []
    for addr, name in note_names():
        target = runtime_address(addr, ranges)
        found = by_addr.get(target)
        if found is None:
            missing.append((addr, target, name))
            continue
        index, line_no = found
        line = files[index][1][line_no]
        old = line.split()[0]
        if old == name:
            continue
        files[index][1][line_no] = name + line[len(old):]
        renamed += 1
        where = "same address" if target == addr else f"runtime {target:08x}"
        print(f"{addr:08x} {old} -> {name} ({where})")

    for path, lines in files:
        path.write_text("\n".join(lines) + "\n")

    print(f"renamed {renamed}")
    if missing:
        print("missing:", file=sys.stderr)
        for addr, target, name in missing:
            print(f"  {addr:08x} -> {target:08x} {name}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
