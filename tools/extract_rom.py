#!/usr/bin/env python3
"""Cut one file out of rom.bin.

The archive starts with little-endian u32 offsets. The first word is the
directory size. Each file is the span from one word to the next. File numbers
match the game: file 1 is the first span.

Example:
    python3 tools/extract_rom.py 1
    python3 tools/extract_rom.py 1 --stdout
    python3 tools/extract_rom.py --list 8
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

EXTRACTED_ROM = Path(__file__).resolve().parents[1] / "extract" / "files" / "rom.bin"
DOWNLOADS_ROM = Path.home() / "Downloads" / "Urbz" / "rom.bin"
DEFAULT_ROM = EXTRACTED_ROM if EXTRACTED_ROM.is_file() else DOWNLOADS_ROM


def load_directory(rom: Path) -> tuple[bytes, list[int]]:
    data = rom.read_bytes()
    if len(data) < 4:
        raise SystemExit(f"{rom} is too small to be rom.bin")
    directory_bytes = struct.unpack_from("<I", data, 0)[0]
    if directory_bytes < 8 or directory_bytes > len(data) or directory_bytes % 4 != 0:
        raise SystemExit(f"first word {directory_bytes:#x} is not a directory size")
    count = directory_bytes // 4
    words = list(struct.unpack_from(f"<{count}I", data, 0))
    if words[-1] != len(data):
        raise SystemExit(
            f"last offset {words[-1]:#x} is not the file size {len(data):#x}"
        )
    return data, words


def span(words: list[int], file_number: int) -> tuple[int, int]:
    file_count = len(words) - 1
    if file_number < 1 or file_number > file_count:
        raise SystemExit(f"file {file_number} is outside 1..{file_count}")
    start = words[file_number - 1]
    end = words[file_number]
    if not (0 <= start <= end <= words[-1]):
        raise SystemExit(f"file {file_number} has a bad span {start:#x}..{end:#x}")
    return start, end


def main() -> None:
    parser = argparse.ArgumentParser(description="Extract one file from rom.bin")
    parser.add_argument("file_number", nargs="?", type=int, help="1-based file number")
    parser.add_argument("--rom", type=Path, default=DEFAULT_ROM)
    parser.add_argument(
        "--list",
        type=int,
        metavar="N",
        help="print the first N files as number, start, end, size",
    )
    parser.add_argument(
        "--stdout",
        action="store_true",
        help="write the file bytes to stdout instead of files/",
    )
    parser.add_argument("-o", type=Path, help="output path")
    args = parser.parse_args()

    if not args.rom.is_file():
        raise SystemExit(f"rom not found: {args.rom}")

    data, words = load_directory(args.rom)
    file_count = len(words) - 1

    if args.list is not None:
        limit = min(args.list, file_count)
        for number in range(1, limit + 1):
            start, end = span(words, number)
            print(f"{number:5d}  {start:#010x}  {end:#010x}  {end - start:8d}")
        print(f"{file_count} files, directory {words[0]:#x} bytes", file=sys.stderr)
        return

    if args.file_number is None:
        parser.error("give a file number, or --list N")

    start, end = span(words, args.file_number)
    blob = data[start:end]
    if args.stdout:
        sys.stdout.buffer.write(blob)
        return

    out = args.o
    if out is None:
        out = Path("files") / f"{args.file_number}.bin"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(blob)
    print(f"file {args.file_number}: {start:#x}..{end:#x} ({len(blob)} bytes) -> {out}")


if __name__ == "__main__":
    main()
