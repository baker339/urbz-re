# Contributing

One pull request, one function. Open an issue with the address before you start, so two people do not take the same one.

You need your own copy of the USA ROM. Its SHA-1 is in `baserom.sha1`. Do not commit a ROM, a `.bin`, `extract/`, or `build/`, and do not ask for a copy.

## Build

Put the ROM at `baserom.nds`. Install ds-decomp 0.12.1 as `tools/dsd` or on your `PATH`. Then:

```bash
python3 tools/build.py
```

The ARM9 bytes in your ROM have to match the split. `dsd check modules` compares a linked binary to those bytes. Linking needs the CodeWarrior linker, and the compiler version is still unknown, so that check is not the one `build.py` runs.

## Name a function

1. Open an issue titled `Claim 02003678`, with the real address.
2. In `config/arm9/symbols.txt`, or the ITCM or DTCM list, rename that one `func_` symbol. Do not change its address or size.
3. Add a row to the names table in `NOTES.md`: the address, the name, and one sentence.
4. Run `python3 tools/build.py` and include the regenerated assembly.

ITCM functions are listed at the address they run from, in `config/arm9/itcm/symbols.txt`. `run_slots` is `01ff89f0`. In the ROM image those bytes sit at `021224b0`.

## Match a function

Not open yet. A matched function is C that compiles to the same bytes. That needs the Metrowerks compiler this game was built with, and the version is not known. The search is tracked in [issue 1](https://github.com/baker339/urbz-re/issues/1). `src/` is the directory matched files will use. A file counts on the progress page when its block in `delinks.txt` is marked `complete`.

## Still open

### ARM7

The helper CPU is not part of the split. `dsd init` wrote the ARM9 main module, ITCM, and DTCM. There are no ARM9 overlays.

Character behavior, missions, dialogue, menus, and `SoundData.rom` are unread. So are the bytes inside a loaded animation file beyond the fields the player reads. The notes file is the map for those. A pull request that documents one of them should add to `NOTES.md` and, when the code is a function, name that symbol.
