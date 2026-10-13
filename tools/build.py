#!/usr/bin/env python3
"""Check the local USA ROM and rebuild the split.

The ROM is not in git. Put it at baserom.nds, or set URBZ_ROM.
ds-decomp 0.12.1 must be at tools/dsd or on PATH.
"""

from __future__ import annotations

import hashlib
import os
import shutil
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXTRACT = ROOT / "extract"
ARM9 = EXTRACT / "arm9"
EXPECTED_VERSION = "0.12.1"
TRAILER_SIZE = 0x18


def fail(message: str) -> None:
    raise SystemExit(message)


def say(message: str) -> None:
    print(message, flush=True)


def dsd_path() -> Path:
    local = Path(__file__).resolve().parent / "dsd"
    if local.is_file() and os.access(local, os.X_OK):
        return local
    found = shutil.which("dsd")
    if found:
        return Path(found)
    fail(
        "dsd 0.12.1 was not found. Download it from "
        "https://github.com/AetiasHax/ds-decomp/releases/tag/v0.12.1 "
        "and save the binary as tools/dsd"
    )


def rom_path() -> Path:
    override = os.environ.get("URBZ_ROM")
    if override:
        path = Path(override)
    else:
        path = ROOT / "baserom.nds"
    if not path.is_file():
        fail(f"ROM not found at {path}. Copy your USA .nds to baserom.nds")
    return path


def check_rom(path: Path) -> bytes:
    data = path.read_bytes()
    digest = hashlib.sha1(data).hexdigest()
    expected = (ROOT / "baserom.sha1").read_text().split()[0]
    if digest != expected:
        fail(f"SHA-1 {digest} is not the USA ASIE ROM in baserom.sha1")
    code = data[0x0C:0x10]
    if code != b"ASIE":
        fail(f"game code is {code!r}, expected ASIE")
    say(f"ROM {digest} ASIE ({len(data)} bytes)")
    return data


def run(dsd: Path, args: list[str]) -> None:
    say("dsd " + " ".join(args))
    subprocess.run([str(dsd), *args], cwd=ROOT, check=True)


def check_arm9(rom: bytes) -> None:
    offset = struct.unpack_from("<I", rom, 0x20)[0]
    size = struct.unpack_from("<I", rom, 0x2C)[0]
    image = rom[offset : offset + size]
    parts = b"".join((ARM9 / name).read_bytes() for name in ("arm9.bin", "itcm.bin", "dtcm.bin"))
    if not image.startswith(parts):
        fail("ARM9 bytes in the ROM do not match the extract")
    trailer = image[len(parts) :]
    if len(trailer) != TRAILER_SIZE:
        fail(f"ARM9 trailer is {len(trailer)} bytes, expected {TRAILER_SIZE}")
    # The trailer is the ITCM and DTCM autoload records: address, size, zero.
    say(f"ARM9 matches the ROM ({len(parts):#x} bytes plus the {TRAILER_SIZE:#x}-byte autoload trailer)")


def main() -> None:
    dsd = dsd_path()
    version = subprocess.run(
        [str(dsd), "--version"], cwd=ROOT, check=True, capture_output=True, text=True
    )
    if EXPECTED_VERSION not in version.stdout:
        fail(f"dsd is {version.stdout.strip()}, expected {EXPECTED_VERSION}")
    rom = check_rom(rom_path())
    run(dsd, ["rom", "extract", "--rom", str(rom_path()), "--output-path", "extract"])
    check_arm9(rom)
    run(dsd, ["delink", "--config-path", "config/arm9/config.yaml"])
    run(dsd, ["dis", "--config-path", "config/arm9/config.yaml", "--asm-path", "asm"])
    subprocess.run([sys.executable, str(ROOT / "tools" / "progress.py")], cwd=ROOT, check=True)


if __name__ == "__main__":
    main()
