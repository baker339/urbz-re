# urbz-re

Decompilation of The Urbz: Sims in the City for the Nintendo DS. The target is the USA cartridge, game code `ASIE`.

The ROM is not in this repository. The game remains with Griptonite Games and Electronic Arts.

Progress is published at <https://baker339.github.io/urbz-re/>. Naming a function and matching its bytes are counted separately. Matched bytes stay at zero until the CodeWarrior version is identified.

## Setup

The SHA-1 of the 32 MiB USA ROM is in `baserom.sha1`. Copy your dump to `baserom.nds` in this directory, or set `URBZ_ROM` to its path.

[ds-decomp](https://github.com/AetiasHax/ds-decomp) 0.12.1 reads that ROM. Download the binary for your machine from the [v0.12.1 release](https://github.com/AetiasHax/ds-decomp/releases/tag/v0.12.1) and save it as `tools/dsd`, or put `dsd` on your `PATH`.

```bash
python3 tools/build.py
```

That checks the checksum, checks the ARM9 bytes against the ROM, and refreshes `asm/`. `extract/` and `build/` stay untracked.

## Layout

- `NOTES.md` is the research map. Read it before tracing startup again.
- `config/` is the ds-decomp split. Function names live in `symbols.txt`.
- `asm/` is the disassembly. `run_slots` and `start_dma` are in the ITCM file, at the address they run from.
- `include/urbz_object.h` is the object layout.
- `src/` is where matched C will go. It is empty.
- `tools/extract_rom.py` cuts one file out of `rom.bin`. After a build, that archive is `extract/files/rom.bin`.

```bash
python3 tools/extract_rom.py --list 8
python3 tools/extract_rom.py 1
```

File numbers match the game. File 1 is the first span in the directory.

How to claim a function is in `CONTRIBUTING.md`.
