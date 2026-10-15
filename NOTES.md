# Urbz notes

Nintendo DS ROM, The Urbz. ARM9 is little-endian ARMv5. Addresses below are runtime addresses in the ARM9 program unless noted.

This file is the map. Add a line when a chat finds something. Do not re-walk startup from scratch.

ARM9 functions read: 280 of about 2,800. About 10%. That 2,800 counts functions that start by saving registers. A fresh count of those prologues is 2,822, so 280 is just under 10% of that stricter count. About 600 other called functions do not start that way, so they are outside this number.

`[████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]` 10%

Overall decomp: under 1%. This counts a matching rebuild of both CPUs and the game files. Reading ARM9 functions is the first slice of that, and none of those functions are rebuilt source yet. `rom.bin` has 13,385 files, unread beyond the eight boot headers.

`[░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]` <1%

## Names

| Address | Name | What it does |
|---|---|---|
| `0200043c` | `wait_vblank` | Waits for the next vertical blank. Thumb `swi 5`. |
| `02000800` | `startup` | Turns interrupts off, sets up the caches, copies the ITCM block, clears memory, and jumps to `main`. |
| `020008d8` | `unpack` | Unpacks bytes by walking backward. `startup` calls it once with a null pointer, so it returns immediately. Nothing else calls it. |
| `02000b00` | `main` | Turns the hardware on, initializes subsystems once, then calls `frame` forever. |
| `02000cb4` | `enable_screen_b` | Turns on the second screen's normal picture. Sets bit `0x10000` in `0x04001000` just before the `frame` loop. |
| `02000ce0` | `frame` | Runs both slots, then waits until two vertical blanks have passed. |
| `02000e20` | `set_mode` | Writes the mode byte at object `+0x104`. Sets bit 0 of `+0x106` and clears `+0x105`. |
| `02000eb0` | `clear_flags` | Clears bits in `flags` at object `+0xc`. |
| `02000ec8` | `set_flags` | Sets bits in `flags` at object `+0xc`. |
| `02001314` | `sort_point` | Writes the four shorts the draw sort reads. A new object stores this at `+0x5c` when that pointer is empty. |
| `02003678` | `on_screen` | Tests one object against the 256 by 192 screen. Overlap sets flags bit `0x1000`. The selected view also sets bit `0x40000000`. |
| `02003a40` | `update_objects` | Walks a slot's object lists and updates each object. Draws when the second argument is 1. |
| `02005a98` | `update_anim` | Steps one object's animation and writes the frame rectangle into the edge fields. |
| `02006224` | `update_slot` | Reads the slot at `027c0004` and calls `update_objects` with that slot's list heads. |
| `02006310` | `alloc_rows` | For each slot, reserves `0xa400` bytes at `02122300 + slot * 0x210` and splits them into `0x148` rows of `0x80` bytes. Also reserves `0x1c0` bytes for the `0x1a4` request. Then enables VRAM banks B and D and sets bit 4 of both display registers. |
| `02006530` | `call_run_bytes` | Jumps to `run_bytes` with the bytes at object `+0x120` and `+0x121`. `follow_link` calls it when the linked animation has finished. |
| `02006548` | `follow_link` | One behavior stored at object `+0x4c`. Watches the mode byte and the linked object at `+0x11c`. When that object's animation has finished, it runs the two bytes and calls `set_mode(object, 1)`. |
| `02006820` | `wobble` | Adds a wave to `pos_b`. X goes through `cosine`. Y goes through `sine`. |
| `02012460` | `lookup_spawn` | Returns the object pointer `spawn` saved. The first argument picks the group, and the second picks the entry. |
| `0201251c` | `check_byte` | Returns `0` when `run_bytes` should skip a byte. A `0` byte is skipped. A `1` is skipped when bit 0 is set at `0212279c`. Any other non-zero byte returns `1`. |
| `02012550` | `run_commands` | Runs the byte at object `+0x121` as a packed list. A word of `0` ends the list. Any other word picks a handler, then the walk steps forward by that handler's stride. |
| `020125c0` | `spawn` | Creates objects for the byte at object `+0x120`. A `0` in an entry means that object has not been created yet. An empty `+0x5c` is filled with `sort_point`. |
| `02012690` | `run_bytes` | Reads the bytes at object `+0x120` and `+0x121`. A byte that passes the check is used: the first goes to `spawn`, the second to `run_commands`. |
| `02016cb0` | `step_affine` | Steps four records of `0x6c` bytes at `02122864 + 8 + slot * 0x1b8`. The slot is the word at `027c0004`. A record is skipped unless bits 0, 1, 2, 3, or 6 of the word at `+0x18` are set. Bit 0 moves the point, bit 2 bounces a scale, bit 1 advances an angle, and bit 3 writes a rotation from `cosine` and `sine`. |
| `02017d60` | `file_field` | Looks up the second argument through `lookup_file`. Bits 0 and 1 of the first halfword pick an address 2, `0x22`, or `0x202` bytes in. That address is returned only when bits 4 and 5 are both set. |
| `02018620` | `blank_display` | Writes 0 to both display registers, `0x04000000` and `0x04001000`. Writes `0x81` to VRAM bank A at `0x04000240`, turning that bank on as background memory. `set_display_a(1, 0, 0)` stays off because the show flag is still 0. |
| `0201a3a8` | `cap_step` | If either axis moved by 9 or more pixels, shortens the step to 8 pixels along that direction. A smaller move is kept. The length uses the hardware square root at `0x040002b8`. |
| `0201a47c` | `step_point` | Updates one point in the current slot. Records are `0x54` bytes inside a `0x150`-byte slot block. The halfword at `02122d6c` selects the motion. The file value for slot 1 index 0 is `0xa010`, so none of cases 0–5 run until that halfword is changed. |
| `0201ab8c` | `clamp_point` | If the byte at record `+0x4e` is set, keeps the point 128 units inside the limits on the first word and 96 units inside the limits on the second. The record is `02122d24 + slot * 0x150 + index * 0x54`. |
| `0201ac5c` | `load_point` | Copies the two words at `02122d28 + index * 0x54 + slot * 0x150` into the pair the caller passed. `scroll_view` passes index 0, left in `r1` from its own second argument. |
| `0201d994` | `add_time` | Adds a 6-byte delta onto the clock at `0214112c`. The fields wrap at 30, 60, 60, and 24. A wrap sets bit 0, 1, 2, or 3 of the result. The short at the start has no wrap. |
| `0201fe44` | `step_cycles` | Steps 12 records of 8 bytes at `0212301c + slot * 0x60`. Bit 0 enables one. Byte `+2` counts down, and at 0 byte `+4` moves between bytes `+3` and `+5`. A second loop of 12 records at `021231dc` stops when the count passes the word at `02122fdc`. That word is `0xe099900a`, so the second loop returns immediately. |
| `02020214` | `init_palettes` | For slot 1, then slot 0, reserves two `0x800`-byte buffers. One is paired with that screen’s background palette and one with its object palette. |
| `02021390` | `apply_flag` | Sets or clears one flag bit. The first byte picks the bit. `1` sets it through `set_flags`. Any other value clears it through `clear_flags`. |
| `02022b00` | `cmd_set_flag` | Command handler 3. Looks up the object from entry bytes `+4` and `+5`. Byte `+6` picks a flag bit. Byte `+7` equal to `1` sets it, and any other value clears it. |
| `02022b34` | `cmd_set_value` | Command handler 2. Looks up the object from entry bytes `+4` and `+5`, stores the short at entry `+6` into object `+0x14`, and sets bit `0x8` on the byte at `+0x106`. A negative short becomes 0. |
| `02022b8c` | `cmd_set_mode` | Command handler 1. Looks up the object from entry bytes `+4` and `+5`, calls `set_mode(object, 1)`, and sets flags bit `0x8`. The entry is 8 bytes. |
| `0202d984` | `set_callbacks` | Stores `01ff8c50` at `02123498` and `01ff82b4` at `0212349c`. Both addresses are functions in the ITCM copy. Other functions load those two words and call them. |
| `0203266c` | `tick_delays` | Returns while the count at `021234a4` is 0. Otherwise counts down byte `+2` of each 8-byte record at `021234a8`. A byte that reaches 0 calls `0203241c` with that record, unless bit 0 of byte `+3` is set. |
| `02032b08` | `load_file` | Loads one file from `rom.bin`. |
| `02032ca8` | `lookup_file` | Returns the pointer already stored for a file. An id of `0x344A` or higher is already a pointer and is returned unchanged. |
| `02032de4` | `age_files` | Walks `0x344a` file slots. A loaded file whose byte at `0213d77c` has bit 7 clear counts down the low 7 bits. At 0, the pointer at `02130654` is cleared. `run_slots` calls it with 0. |
| `02033050` | `init_fs` | Sets up the filesystem for the device named `rom`. `main` calls it once, with interrupts on, before the boot files are loaded. |
| `02033760` | `copy_blocks` | Copies blocks of words for the current slot. The block size is the word at slot-block `+0x24`. It does not read the 32-piece list. |
| `02033a48` | `load_boot_file` | Loads one of the eight boot files and copies its header into the `0x14`-byte record at `02140d60`. |
| `02034754` | `attach_file` | Attaches one loaded boot file to the current slot. The slot word is `027c0004`. The `0x3c`-byte block starts at `02140ce8`. |
| `02034924` | `load_boot_files` | Calls `load_boot_file` for indexes 0 through 7, then clears the slot blocks at `02140ce8`. |
| `02035e40` | `alloc_extra` | Calls five setup functions. One returns immediately. The others reserve a `0x400`-byte block, an `0x8c00`-byte block, and two `0xc80`-byte row lists. |
| `02039ba4` | `record_active` | Returns 0 only when the word at `02141c70 + index * 0x40` is 0 and the short at `02141c80 + index * 0x40` is 0. Any other case returns 1. |
| `02039bec` | `mark_record` | On the record selected by the halfword at `02141d74`, ORs 3 into the word at `+4`. If the short at `+0x12` differs from a 0-to-43 level, it refreshes that short first. |
| `0203a15c` | `update_record` | Handles one `0x40`-byte record at `02141c70`. The flag word at `02141c74` gates the branches. A zero flag word skips them. `update_list` calls it with index 0. |
| `0203af6c` | `read_input` | On slot 0, reads the buttons from `0x04000130` and the halfword at `027fffa8`. Stores held, previous, pressed, and released at `02141dc6`. A nonzero byte at `02141d70` skips that and clears the block instead. |
| `0203b310` | `mark_block` | Clears the byte at `02141d70` and a run of halfwords in that block, then stores the halfword 1 at `02141d72`. |
| `0203b37c` | `start_vblank` | Replaces the V-Blank handler with `01ff86fc`, sets IE bit 0 and DISPSTAT bit 3, turns the master interrupt switch on, and stores `0203b344` at `027c0028`. |
| `0203b3dc` | `set_frame_counter` | Stores `027c0028` at `027c0020`. `frame` reads the counter through that pointer, so the new count is at `027c0044` and the accepted count is at `027c0048`. |
| `0203e6fc` | `show_label` | Shows one label, picked by the argument. Cases 0–4 run when the word at `027c0084 + slot * 0x8c` is 0. Cases 5 and 10–18 run only when that word is 8. The two bytes at `020c77b4 + index * 2` are the position. `020a6d28` looks up the text in the `0x400`-byte block at `02148f74`. |
| `02046af4` | `id_matches` | Returns 1 when the id byte equals one of three bytes in the 8-byte record at `020c812c`, or one of 11 bytes at `020c8110`. The record is selected by the first byte of the block passed in. |
| `0204c014` | `update_list` | Entry 1 of the table `call_entry` uses. Walks the count at `02141d72`, which `mark_block` set to 1, and updates the `0x40`-byte records at `02141c70`. |
| `0204d51c` | `clamp_positive` | Turns a negative short into 0 and keeps a positive short. `cmd_set_value` uses it on the short at entry `+6` before storing it at object `+0x14`. |
| `0204da30` | `cosine` | Adds `0x40` to the angle index and jumps to `sine`. That is one quarter turn. |
| `0204da44` | `sine` | Looks up one quarter of a 256-step circle. The peak value is `0x10000`, one pixel. |
| `0204dce0` | `call_entry` | Calls the function at `020cd8b8 + index * 0xc`, where the index is the first word of the slot record at `027c0070`. A 0 pointer returns. The table has 43 entries. Entry 0 returns immediately. Entry 1 is `update_list`. |
| `0204dd3c` | `call_mode` | Calls the function at `020cd8b4 + index * 0xc`. The index is the first word of the slot record at `027c0070`. A 0 pointer returns. Slot 0’s index is 0, and that entry is `bx lr`. |
| `0204de58` | `record_changed` | Returns 1 when the word at `027c0070 + slot * 0x8c` differs from the word `0x2c` bytes later. `init_slots` copied those words, so they start equal and this returns 0. |
| `0204e0e0` | `init_slots` | Clears the two `0x8c`-byte records at `027c0070` and `027c00fc`. Copies the first 11 words into the two groups at `+0x2c` and `+0x58`, then writes `0x83` at `+0x2c`. Slot 0 also reserves `0x800` bytes. |
| `0204e3d8` | `zero_memory` | Writes zeros through a range of bytes. `load_boot_files` uses it to clear `0x3c` bytes at each slot block. |
| `0204e570` | `take_main_memory` | Reads arena 0, the free main RAM from `0214de20` to `023c0000`. Rounds the ends to multiples of 32, which they already are, then saves that range and adds 1 to the count at `02142000`. |
| `0205dafc` | `clear_state` | Stores 0 at `02142100`, `0214210c`, and `02142110`. A nearby function sets those same words to 1. |
| `02064f3c` | `do_nothing_3` | Returns immediately. The bytes are `1e ff 2f e1`. `alloc_extra` calls it. |
| `02066110` | `tick_events` | Returns while the byte at `02142234` is 0. Otherwise ticks ten 6-byte timers at `02142270` and counts down the word at `02142238`. The scan of ids `0x1f` through `0x50` runs only on the call where that word was already 0, then stores `0x96`. |
| `02066bb8` | `hide_sprites` | From the byte at `021435d5 + slot * 0x132c` through index 127, sets bits 8 and 9 of each 8-byte entry to the hidden value `0x200`. It does that in both banks, `0x400` bytes apart, inside the slot block at `021422ac`. Then stores 1 at `027c0060 + slot`. |
| `02067134` | `init_slot_blocks` | Builds a `0x132c`-byte record per slot at `021422ac`. The first word points 8 bytes into the record. Slot 0’s next word points at `02142ab4`. The helpers run once with the slot at 1 and once at 0. |
| `0206a0f0` | `clear_link` | Clears bit 0 of the object's flags, then stores 0 at `+0x120` and `+0x11c`. `find_target` calls it with the word at `02144938` when the mode byte is not `0x10`. |
| `0206ed04` | `walk_links` | Returns while the halfword at `02144b80 + slot * 0x150` is 0. Otherwise walks the list at `+4` of that record. Bit 15 of the word at record `+0x30` skips `0206e440`, and that bit is then cleared. |
| `0206f36c` | `alloc_slot_rows` | For each slot, at `02144a48 + slot * 0x150`, reserves `0x54` rows of `0x14` bytes and `0x48` rows of 5 bytes, plus four `0x60`-byte blocks. Clears the words at `+0` and `+4`. |
| `020713e8` | `init_node` | Points `02144ce8` at `02144d44` and fills that record: `0`, `1`, `0`, `-1`, and the halfword `0xffff` at `+0x10`. Also points `02144cec` at `02144d30`. |
| `0207a1d0` | `seed_block` | Asks channel 5 to fill stack values, packs them into one word at `02146f08`, adds 1 to `02146f0c`, and writes that word into the block at `02146ef8`. |
| `0207a25c` | `alloc_block` | Asks the main-memory range for `0x9c4` bytes. The allocator rounds that up to `0x9e0` and stores the pointer at `02146ef8`. |
| `0207dd2c` | `step_tasks` | If the byte at `02146f18` is 0, returns. Otherwise walks the three `0xa0`-byte records at `02146f1c`. State bytes 0 and 1 clear a record. State 2 or 3 calls the function at `020f7254 + index * 8`. |
| `0207ee88` | `init_header` | Reserves `0xfe0` bytes and stores the pointer at `0214711c`. On a zeroed header, copies `URBZ0010` from `020f7328` to `021470fc`, clears the block, and passes `(0x20, 0x40)` and `(0x1000, 0x40)` with that pointer. |
| `020806a4` | `slot_pending` | Returns 1 when the word at `02147194 + slot * 0x20` is not 0. `init_fade` stored 0 there, so `run_slots` skips the next block. The slot is the word at `027c0004`. |
| `02080814` | `flag_slot` | ORs `0x4000` shifted by the slot into `027c0008`, and ORs 5 into the word at `02147194 + slot * 0x20`. That is the word `slot_pending` tests. |
| `0208093c` | `set_fade` | Stores the second argument in the current slot’s record at `0214719c + slot * 0x20`, then calls `02080584`. Command `0x3f` writes the master brightness. `main` uses slot 1, then slot 0, both with `0x10`, writing `0x4010` to `0x0400106c` and `0x0400006c`. |
| `02080964` | `init_fade` | Writes `1`, `0`, and `0x3f` at `02147190` and again at `021471b0`. Those are the two slot records. `set_fade` stored `0x10` just after each group, at `0214719c` and `021471bc`. |
| `02080ed0` | `load_map_size` | Copies the two words at `021472a0 + slot * 0x114` into the pair the caller passes. That is `0xd0` bytes into the same slot record `scroll_view` uses. The first word is the width and the second is the height. |
| `02081074` | `cache_tile` | Finds a tile in the layer cache, or copies its 32 bytes into background memory and returns the new index. A tile already cached has its count increased instead. |
| `02081204` | `write_row` | Wraps an X into the map width, then writes 33 background-map entries across the strip through `cache_tile`. The step is 8 pixels. Slot 0 uses `0x06000000` and slot 1 uses `0x06200000`. |
| `02081468` | `write_column` | Wraps an X into the map width, then writes 25 background-map entries down the strip. Slot 0 uses `0x06000000` and slot 1 uses `0x06200000`. |
| `02081684` | `load_row` | Uses the same wrap as `load_column`, then releases 33 cached tiles across the strip for each enabled layer. The step between tiles is 8 pixels. |
| `020817e0` | `load_column` | Wraps an X into the map width, then releases 25 cached tiles down the strip for each enabled layer. A width of 0 never leaves the wrap, because subtracting 0 leaves the position at 0. |
| `02081904` | `release_tile` | Looks up a tile in the layer's chain at `021472b0`. A missing tile returns 1. A found tile loses one from its count, and a count of 0 unhooks that 6-byte record. |
| `02081aac` | `flush_scroll` | For two pairs at record `+0x30` and `+0x38`, a value other than `-1` is passed to `load_column` or `load_row`, and then both words are set to `-1`. Then the view at `021471f0` is copied to `021471f8`. |
| `02081b80` | `queue_scroll` | Stores the two arguments at `02147200 + slot * 0x114 + which * 8`. Those are the pairs `flush_scroll` later reads at record `+0x30` and `+0x38`. `which` is 0 or 1. |
| `02081bc0` | `scroll_view` | Turns the current point into the top-left of a 256 by 192 view and keeps that view inside the map. A change of 8 pixels loads the new row or column. `update_list` calls it as `scroll_view(0, 0)`. |
| `020823e8` | `do_nothing_4` | Returns immediately. The bytes are `1e ff 2f e1`, which is `bx lr`. |
| `02083cb8` | `adjust_level` | Compares a new level with the top byte of the word at `02141220`. A higher new level calls `0205dc20` with `0x27`. A lower one calls it with `0x29`. An equal level returns. |
| `02083db0` | `step_state` | Asks `add_time` about the 6-byte entry. If bits 1–3 of the result are clear, it returns. Otherwise it sets bits 0 and 1 on the current `0x40`-byte record and steps the block at `02141120`. |
| `020840f4` | `set_delta` | Stores one byte at `021473f8`. That byte picks the 6-byte clock delta at `02113b5c`. `find_target` reads it, then calls this with 0. |
| `02084104` | `find_target` | Clears `021473fc`, then looks at the object pointer in `02141c2c`. Mode `0x10` at object `+0x104` searches the list at `0214490c` and may store that object's `+0x24` into `021473fc`. A newly pressed B button calls through the pointer at object `+0x100`. |
| `020923ac` | `scan_channels` | Reads the count byte at `0214869a`. From count minus 1 down to 0, an index whose bit is clear in the word at `021488f4` is passed to `update_channel` with 0. A count of 0 returns immediately. |
| `020929f8` | `update_channel` | One channel. The `0x18`-byte record is at `02148c00 + index * 0x18`, and the link byte is at `021479cc + index * 0x20 + 10`. A second argument of 0 calls `mix_channel` with the index and stores `0xff` in that link byte. `0xff` as the index returns immediately. |
| `02095450` | `set_scale` | Clamps the argument to `0x20` through `0xff` and stores it at `02147520 + 0x21`. Two fifths of that value, rounded down, divides the word at `02148680` shifted left 8. The hardware divider is `0204d964`. The quotient, shifted left 8, is stored at `02148684` and `02148688`. |
| `02095664` | `free_copy` | Frees the block `flush_block` copies to `02147520`. Byte `+0x1c` being 1 or 2 calls `scan_channels` and clears it. Bit 7 of byte `+0x23` is the release. Bit 1 of byte `+0x1d` chooses a full free, ending in `reset_buffer`, or just storing 0 at `0214751c`. The block starts cleared, and `flush_block` does not call this on the first frame. |
| `0209586c` | `apply_copy` | Runs when byte `+0x1c` of the block at `02147520` is 2. Copies `0x18`-byte records from `02148900` into `02148c00` for each index whose bit is clear in the word at `021488f4`. A set bit stores `0xff` into the link byte instead. Then stores 1 at byte `+0x1c`. |
| `02096adc` | `flush_block` | Tests the word at `0214868c`. Bit 5 copies `0x8ac` bytes from `02147dcc` to `02147520`, clears three source bytes, and then clears the bit. Bit 4 only calls `free_copy` and clears itself. Both bits are clear on the first frame, so it returns. |
| `02097d18` | `mix_channel` | If the channel's first word is set, multiplies one sample by the halfwords at `+0xc` and `+0xe`, shifts each product right 9, and adds them to the shorts at `02148690` and `02148692`. Then stores 0 in the channel word. A zero word returns. |
| `02097dc0` | `set_rate` | If the argument differs from the halfword at `02148698`, stores it there. Divides `0xffb0ff` by that value, rounds the quotient to a multiple of 32 at `02148696`, and divides `0xffb0ff` by the rounded value into `02148680`. Then calls `set_scale`. A new value while bit 2 of `0214868c` is clear also calls `mark_once` and `reset_buffer`. |
| `02097e6c` | `pick_table` | Bit 0 of the argument picks a `0x30`-byte table. Clear copies `020b42a4` onto `020b4274`. Set copies `020b42d4`, which already matches those bytes. The whole argument is then stored at `0214868c`. |
| `02097ec0` | `pump_audio` | Reads the flag word at `0214868c`. Bit 2 set and bit 3 clear returns. Bit 3 set clears the halfword at `02148694` and bit 7 of byte `+0x1c` at `02147520`, then starts eight channels through `send_channel`, calls `queue_reply` and `queue_nine(0xff, 0, 1, 0)`, and clears bits 2 and 3. Both bits clear consumes that halfword as a sample count. |
| `020973cc` | `add_count` | If bit 2 of the word at `0214868c` is clear, adds `0x100` to the halfword at `02148694`. That halfword is the sample count `pump_audio` consumes. A set bit returns without adding. |
| `020973ec` | `apply_mix` | Adds the shorts at `02148690` and `02148692` into the two buffer halves, clamped to `-0x8000` through `0x7fff`. Each sample then shrinks those shorts by `(count - 1) / count`. The empty loop waits on divider bit 15 at `0x04000280`. The shorts are cleared at the end. |
| `0209823c` | `free_channels` | Walks 16 records of `0x20` bytes from `02148880` down to `021486a0`. A record whose first word is set is freed through `0204e4b4` when its countdown hits 0, or when bit 7 of byte `+0xe` is clear and the `0x18`-byte record at `02148c00` is empty. `clear_area` zeroed this block, so the first call frees nothing. |
| `02098388` | `reset_buffer` | If bit 2 of `0214868c` is clear, returns. Otherwise clears `0x2000` bytes at the pointer in `0214867c`, divides the word at `02148680` by `0x3c0ded` on the hardware divider, stores a scaled halfword at `02148694`, copies the pointer to `02148678`, clears `02148690`, and sets bit 3 of `0214868c`. |
| `02098420` | `mark_once` | If bit 2 of `0214868c` is clear, adds 1 to the byte at `0214cd88`, sets that bit, and sets bit 7 of the byte at `0214753c`. Later calls return immediately. |
| `0209858c` | `clear_area` | Clears `0x260` bytes at `021486a0`, then stores the byte `0x20` at `021488fa`. `FUN_02098488` then clears `0x28` bytes at `02148678` and `0xc00` bytes at `02148c00`. |
| `020a6e50` | `reserve_block` | Looks up file `0x37` from the table at `0211be40`, stores the byte `0x2e` at `02148f70`, then asks the main-memory range for `0x400` bytes and stores that pointer at `02148f74`. |
| `020ae578` | `clear_slot_buffers` | Saves the slot, then for slot 0 and slot 1 clears `0x400` bytes at `02149864 + slot * 0x400` and fills `0x400` bytes at `02149064 + slot * 0x400` with `0xff`. Restores the slot afterward. |
| `020aee70` | `step_motions` | Two records of `0x3c` bytes at `0214a064 + slot * 0x78`. Each holds two motions. Bit 1 of a motion moves its point: a countdown of 0 adds the step, 1 snaps to the target and clears the bit, and any other value steps toward the target. The base is past `arm9.bin` and starts cleared, so all four motions are skipped. |
| `020abd18` | `clear_entry` | For one index, stores the pointer `02148fec` at `02148fe8 + index * 16`, stores 0 at `02148fec + index * 16` and `02148ff4 + index * 16`, and clears bit 0 of the byte at offset 8. |
| `020abd58` | `init_four` | Calls `clear_entry` with 0, 1, 2, and 3. The early return Ghidra marked unreachable is the check before the first pass, and the counter starts at 0. |
| `020b4304` | `blend_up` | Same four byte blends as `blend_wrap`. After each step, a negative position subtracts the loop length shifted up by 16 until the position is zero or positive. `blend_wrap` does that subtract while the position is zero or positive. |
| `020b4418` | `rest_bytes` | A byte-for-byte copy of `blend_rest`. The scratch word is the one at `020b4414`, and the skip stub is at `020b44fc`. Same blend, and the handler is replaced once the position reaches zero. |
| `020b4504` | `next_node` | A second argument of 0 returns the header's first word, the head. Otherwise it returns the next word at `node + offset + 4`. The offset is the halfword at header `+10`. |
| `020b451c` | `unlink_record` | Removes a record from the doubly linked list whose header is the first argument. The halfword at header `+10` is the offset of the previous and next words. The halfword at header `+8` is the count, and it drops by 1. |
| `020b458c` | `link_node` | Appends the node at the tail. Its previous word becomes the old tail and its next word becomes 0. The header's second word moves to the new node, and the count at header `+8` increases by 1. An empty list calls `first_node` instead. |
| `020b45f8` | `first_node` | Stores 0 in both of the node's link words. The header's first and second words both become this node, and the count at header `+8` increases by 1. |
| `020b4f54` | `flush_pending` | Calls `reclaim_list(0)` until it returns 0, then calls `step_nodes`, `step_span`, and `step_four`. `file_queue(0)` tries to send the queue once and does not wait. |
| `020b4f88` | `init_records` | Runs once. Clears three words at `0214a18c` and two words at `0214a9fc` and `0214aa14`. Builds 32 records of `0x1c` bytes at `0214a1b0`, then 16 records of `0x44` bytes at `0214a530`. The first of those 16 is linked from `0214a198`. |
| `020b5120` | `step_nodes` | Walks the list at `0214a1a4`. When `count_reached` accepts the word at `+0x30`, byte `+0x2d` becomes 1. A set byte whose bit is clear in the mask from `second_word` calls `retire_node`. Otherwise `raise_count` runs on the block at `+0x1c`. The third table index is `slide_value` on that block, shifted right by 8. Three signed halfwords from `0211c850` are added, and a new sum is passed to `report_sum`. Byte `+0x2c` equal to 2 and `count_done` on that block calls `finish_node`. |
| `020b4fd0` | `clear_mask` | Clears bit `1 << index` in the word at `0214a190`. The shift uses the low 8 bits of the index. `init_records` cleared that word, so it starts at 0. |
| `020b4ff0` | `clear_held` | Clears the argument's bits in the word at `0214a18c`. `close_span` passes the word at `+0x24`. No command is filed. |
| `020b500c` | `clear_bits` | Calls `queue_23` with the mask and 0. Then clears those bits in the word at `0214a194`. A mask of 0 returns. |
| `020b5070` | `retire_node` | Clears the node's first word through the pointer it holds, unlinks the node from the list stored at `+4`, and moves the pointer at `+8` onto the list 12 bytes after that header. Then moves the node itself from `0214a1a4` onto `0214a198` and stores 0 in byte `+0x2c`. |
| `020b5100` | `finish_node` | Passes the byte at `+0x3c` to `queue_one`, then calls `retire_node`. `step_nodes` does this when byte `+0x2c` is 2 and `count_done` returns 1. |
| `020b530c` | `release_record` | Passes the word at `+0x28` to `clear_mask`, then calls `unlink_record` with `0214a970` and the record. Clears bits 0 and 1 of the word at `+0xc`. |
| `020b5350` | `clear_bit` | If bit 1 of the word at `+0xc` is set, passes the same four values as `queue_bit` to `queue_ten`, clears that bit, saves `read_count`, and calls `file_queue(1)`. The saved value is then passed to `wait_count`. `release_record` runs either way. |
| `020b53c4` | `spread_sum` | Stores the new sum at `+0x24`. If the count at `+0x30` is 0 or negative, returns. Otherwise each byte at `+0x34` picks an 8-byte entry at `0214a97c`, and `queue_17` is called with `1` shifted by that byte and the two halves of `pack_level`'s result. |
| `020b5438` | `pass_record` | If bit 0 of the word at `+0xc` is set, calls `clear_bit` with the record still in `r0`. A clear bit returns. |
| `020b5468` | `queue_bit` | Queues command 9. The first word is the word at record `+0x2c`. The third word is `1` shifted by the low 8 bits of the word at `+0x28`. Then sets bit 1 of the word at `+0xc`. `step_four` passes each of the four records at `0214aa7c`. |
| `020b54a4` | `clear_source` | If the word at `+0x2c` is not 0, calls `clear_bits` with that word still in `r0`, then stores 0 at `+0x2c` and `+0x30`. |
| `020b54d4` | `close_span` | Shuts down the record at `0214aa14` and stores 0 in its first word. `queue_ten` gets the words at `+0x20` and `+0x24`, and a nonzero `+0x24` is also passed to `clear_held`. A word at `+0x28` of 0 or more also sends `1` shifted by that word's low 8 bits, then waits out `file_queue(1)`, calls `take_one` on `0214aa00` until it returns 0, and calls `clear_mask` with that word. A nonzero word at `+0x1c` is passed to `clear_bits`. If the word at `+4` is 1, `queue_21` is called with four zeros. |
| `020b55c0` | `step_span` | One record at `0214aa14`. A zero first word returns, and a nonzero word at `+4` returns. Otherwise `raise_count` runs on the block at `+0x38`. A nonzero word at `+0x48` with `count_done` calls `close_span`. Otherwise `slide_value` shifted right by 8 is compared with the word at `+0x4c`, and a change calls `queue_17` with the word at `+0x20`. |
| `020b5690` | `pass_node` | With interrupts off, calls `link_node` with the header at `0214aa64` and the node. That header is the 12 bytes just before the list at `0214aa70`. |
| `020b56c8` | `lower_count` | If the word at `+0x100` is 0, returns. Otherwise subtracts 1. When that reaches 0, calls `clear_source` with the record still in `r0`. |
| `020b5718` | `finish_record` | Clears the pointer at `+0x114` and the word it points at, then calls `lower_count`. Bit 4 of the word at `+0x50` calls `reset_block` on `record + 0x44`. Walks the list at `0214aa70` with `next_node` and unlinks every node whose word at `+8` is this record, then calls `pass_node` on that node. Clears bits 0, 1, and 2 of the word at `+0xf0`. |
| `020b57f4` | `close_record` | If bit 1 of the word at `+0xf0` is set, calls `pass_record` with the record still in `r0`. Then always calls `finish_record` with the record. |
| `020b5820` | `step_four` | Walks four records of `0x12c` bytes from `0214aa7c`. Bit 0 of the word at `+0xf0` has to be set. A nonzero word at `+0xf4` calls `close_record` and skips the rest. Bit 2 with a nonzero word at `+0xf8` calls `queue_bit`, then sets bit 1 and clears bit 2. Bit 1 adds two signed halfwords from `0211c850`. A changed sum is passed to `spread_sum`. Bit 3 with `count_done` on the block at `+0xc8` calls `close_record`. |
| `020b593c` | `count_done` | Returns 1 when the signed word at `+8` has reached the signed word at `+0xc`. Otherwise returns 0. |
| `020b5954` | `raise_count` | If the signed word at `+8` is still below the signed word at `+0xc`, adds 1 to the word at `+8`. `step_nodes` passes `node + 0x1c`. |
| `020b5974` | `slide_value` | While the signed word at `+8` is below the word at `+0xc`, returns the word at `+0` plus `(+8) * ((+4) - (+0))` divided by the word at `+0xc` through `divide_signed`. Once `+8` has reached `+0xc`, returns the word at `+4`. |
| `020b5ea8` | `do_nothing` | Returns immediately. `main` calls it just before `FUN_020b5ffc`. |
| `020b5ef4` | `set_display_a` | Writes the first screen's display register. Saves the mode ushort at `0214af2c`. If the flag at `0212195c` is 0, the mode is forced to 0. |
| `020b5f68` | `show_display_a` | Puts the saved mode back on the first screen. A saved 0 becomes mode 1, the normal picture. Sets the flag at `0212195c` to 1. |
| `020b5fb4` | `hide_display_a` | Saves bits 16 and 17 of the first screen into `0214af2c`, clears the flag at `0212195c`, and clears those two bits so the picture is off. |
| `020b5ffc` | `reset_display` | Turns the screens on, disables VRAM, clears both display register blocks, and sets background 2 and 3 on each screen back to normal size. |
| `020b6158` | `disable_vram` | Disables every VRAM bank by writing 0 to `0x04000240`–`0x04000246` and `0x04000248`. Also clears 13 ushorts at `0214af30`. |
| `020b6ae0` | `allow_interrupts` | Turns the master switch `0x04000208` off, ORs the argument into the enable mask `0x04000210`, restores the switch, and returns the old mask. `main` calls it with 1, then with `0x40000`. |
| `020b6b4c` | `set_irq_handler` | For each set bit in the mask, stores a handler. Bits 0–2, 7, and 12–21 write one word in the table at `02121974`. Bits 3–6 and 8–11 write a 12-byte record at `0214af4c`: the handler, then 1, then 0. `main` passes mask 1 and `02000c94`, so only the V-Blank slot changes. |
| `020b6bdc` | `clear_flag` | Stores the halfword 0 at `027c0188`, which is `0x188` bytes into the block copied to `027c0000`. Later code treats a nonzero value there as a one-shot. |
| `020b6efc` | `init_lock` | Runs once. Takes id `0x7e` on the word at `027ffff0`, waits until the halfword at `027ffff6` is 0, fills the small table at `027fffb0`, gives both cartridge slots to the ARM7, releases `0x7e`, and takes id `0x7f`. |
| `020b6fec` | `halt` | Turns interrupts on, then waits for an interrupt forever. `fill_heap_head` stores `020b6ff0`, the instruction after the register save. |
| `020b7000` | `set_heap_word` | With interrupts off, replaces the word at heap header `+0x10` and returns the old word. `init_heap` passes 0. |
| `020b70f0` | `switch_heap` | If the CPU is in interrupt mode, or a ushort flag is set, stores 1 and returns. Otherwise compares two heap records and may switch. |
| `020b71b8` | `find_marked_heap` | Walks the heap list at header `+0xc` and returns the first heap whose `+0x64` is 1. Returns 0 when none is marked. |
| `020b7710` | `save_context` | Saves the CPU state into the heap record and returns 0, so `switch_heap` takes the normal switch path. Calls `save_divider` with the record plus `0x48` first. That copies the divider numerator from `0x04000290`, the denominator from `0x04000298`, the square-root input from `0x040002b8`, and the mode bits from `0x04000280` and `0x040002b0`. |
| `020b72f4` | `release_heap` | Turns interrupts off, loads the heap record through header `+8`, clears that heap's slot, and sets `+0x64` to 2. |
| `020b7218` | `mark_heaps` | Loads the halfword at the pointer it is given and uses that as the mask. For each heap whose slot bit is set, `+0x64` is set to 1. Then the mask is cleared. |
| `020b728c` | `yield_heap` | With interrupts off, ORs `1 << slot` into the halfword argument when it is not 0. The slot is the low 8 bits of the word at `+0x6c` of the heap record reached through `0214afb4`. Stores 0 at that record's `+0x64`, then calls `switch_heap`. |
| `020b734c` | `add_heap` | With interrupts off, picks a slot, writes the two end markers, and clears the bytes between them. `init_heap` uses it for a `0xc8`-byte range ending at `0214b200`. |
| `020b744c` | `init_heap` | Runs once. Records the free range `027c01a0`–`027c37c0` and writes a marker at each end. |
| `020b775c` | `restore_context` | Calls `restore_divider` with the record plus `0x48`, loads the saved registers, and resumes with `subs pc, lr, #4`. That instruction is the jumptable warning. |
| `020b7614` | `insert_heap` | Links a heap into the list at header `+0xc`. The next heap is `+0x68`. Smaller `+0x70` values come first. |
| `020b76ac` | `fill_heap_head` | Fills the front of a heap record. Stores `0x1f` when the code pointer is even and `0x3f` when it is odd. Zeros the words from `+4` through `+0x34`, and the word at `+0x3c`. |
| `020b767c` | `find_heap_slot` | Returns the index of the first zero word in the 16 slots at heap header `+0x14`. Returns `-1` when all 16 are full. |
| `020b7abc` | `drain_heap` | If the word at `+0x7c` is 0, returns. Otherwise takes items from `pop_heap_node` until that word is 0. |
| `020b7928` | `take_one` | If the word at `+0x10` is 0 and bit 0 of the third argument is set, calls `yield_heap` with `block + 2` until the count is nonzero. Otherwise returns 0. A nonzero count stores the word at `base[index]` through the second argument when that pointer is set, sets the index at `+0xc` to the remainder of `(index + 1) / word at +8`, subtracts 1 from the count, and calls `mark_heaps` with the block. Returns 1. |
| `020b79d8` | `pop_heap_node` | Removes the first node in the list at heap record `+0x7c` and returns it. The next node is at the node's `+0x10`. `+0x80` is cleared when the list becomes empty. |
| `020b7c54` | `invalidate_lines` | Drops one 32-byte data-cache line at a time from the aligned start through `start + length`. `fresh_word` passes the shared block and `0x280`. |
| `020b7c70` | `clean_lines` | Writes each dirty 32-byte data-cache line back to main memory, then drops it. `file_queue` passes the command records at `0214b580` and `0x1800`. |
| `020b7cb4` | `init_subsystems` | Calls the IPC handshake, `init_heap`, and several other setup functions. `main` calls `init_heap` again afterward, and that second call returns immediately. |
| `020b7e70` | `do_nothing_2` | Returns immediately. `init_subsystems` calls it. The bytes are `1e ff 2f e1`, which is `bx lr`. |
| `020b7e74` | `init_arenas` | Runs once. Writes the low and high address of seven memory areas into tables at `027fe23c` and `027fe260`. |
| `020b8144` | `init_irq` | Installs `020b7fc0` as the ARM9 interrupt handler at `027ffd9c` and `027c3fdc`, unless a handler in `02600000`–`027fffff` is already saved and bit 30 of the check word is set. |
| `020b81d4` | `clear_vcount` | Runs once. Clears the two words at `0214b294`, then clears bit 2 of `0x04000210` while `0x04000208` is off. Bit 2 is the V-Counter interrupt. |
| `020b7920` | `return_zero` | Returns 0. `main` would store 1 vblank if this returned anything else, so `frame` keeps waiting for two. |
| `020b8228` | `enable_irq` | Clears the interrupt-disable bit and returns the old flag. |
| `020b823c` | `disable_irq` | Reads the interrupt flag, turns interrupts off, and returns the old flag. |
| `020b8250` | `restore_irq` | Writes that saved flag back. |
| `020b82a0` | `wait_irq` | Puts the CPU to sleep until the next interrupt. `mov r0, #0`, then the coprocessor wait. |
| `020b82ac` | `busy_wait` | Subtracts 4 and repeats while the value before that subtract was at least 4. `wait_channel` passes 100. |
| `020b82cc` | `on_channel_12` | Handler for channel 12. If bits 8–14 of the message are `0x10`, stores the halfword 1 at `0214b2a0`. Any other value does not return. |
| `020b8310` | `init_channel_12` | Runs once. Waits until bit 12 is set at `027fff8c`, then stores `on_channel_12` at `0214ce18` and sets bit 12 at `027fff88`. |
| `020b8378` | `set_wram` | Stores one byte at `0x04000247`. `init_subsystems` passes 3, which gives all 32KB of shared WRAM to the ARM7. |
| `020b842c` | `dma_fill` | Fills a range through DMA channel `param_1`. Boot uses channel 3 to fill display registers with 0. Waits while bit 31 of the channel control word is set. |
| `020b84c8` | `fill_words` | Writes one value, as a word, from a start address through a byte count. `add_heap` uses it to store 0 between the two markers. |
| `020b85d4` | `copy_bytes` | Copies the third argument's number of bytes from the first pointer to the second. A count of 0 returns. Even addresses are copied 4 bytes at a time. An odd destination copies one byte first. `build_path` uses it for the leading bytes, `:/`, and each name. |
| `020b8924` | `init_channel_7` | Runs once. The word at `0214b2a4` stops a second call. Calls `init_queue`, then `020b93e4`. |
| `020b8964` | `queue_command` | Asks `take_record` for a record. A 0 return leaves. Otherwise the five arguments are stored at `+4` through `+0x14`. `link_record` then links that record: `0214b2b0` stays at the first one, and `0214b2b4` moves to the newest. |
| `020b89bc` | `queue_three` | Calls `queue_command(3, first, second, third, fourth)`. `report_sum` passes the node's byte, 6, the new sum, and 2. |
| `020b89f0` | `queue_21` | Calls `queue_command(0x15, first, second, third, fourth)`. `close_span` passes four zeros when the word at `+4` is 1. |
| `020b8a50` | `send_channel` | Packs a command numbered 11 and passes it to `020b8964`. For `pump_audio`, the channel is in the low half of the next word and the halfword at `02148696` is in the high half. The pointer is the word after that. The other two packed words are `0x7f000400` and `0x01000000`. |
| `020b8ad4` | `queue_17` | Calls `queue_command(0x11, first, second, third, 0)`. `step_span` passes the word at `+0x20`, the shifted slide value, and 0. |
| `020b8b34` | `queue_23` | Calls `queue_command(0x17, first, second, 0, 0)`. `clear_bits` passes the mask and 0, so the command words are `0x17`, the mask, and three zeros. |
| `020b8b8c` | `queue_reply` | Calls `set_reply` with the first, fourth, and fifth arguments, then `queue_command(0xf, first, second, third, new tag)`. `pump_audio` passes index 0, function `add_count`, argument 0, and the halfword at `02148696` shifted left by 3. |
| `020b8bd0` | `queue_ten` | For each set bit in the low 8 bits of the third argument, calls `bump_tag` with that bit's index. Then calls `queue_command(10, first, second, third, fourth)`. |
| `020b8c40` | `queue_nine` | Passes 9 and then its four arguments to `queue_command`. `pump_audio` calls it as `(0xff, 0, 1, 0)`. |
| `020b8c74` | `report_sum` | Tail-calls `queue_three` with the node's byte, 6, the new sum, and 2. The branch at `020b8c84` is that jump. `step_nodes` calls it when the stored halfword at `+0x3e` changes. |
| `020b8c8c` | `queue_one` | Calls `queue_command(1, first, 0, 0, 0)`. `finish_node` passes the byte at `+0x3c`. |
| `020b8cb8` | `pop_record` | Pops the record at `0214b2a8`. Its first word becomes the new head. If that word is 0, `0214b2b8` is cleared. An empty list returns 0. The popped record stays in `r0`. |
| `020b8cf0` | `send_zero` | Calls `send_fifo(7, 0, 0)` and repeats while the result is negative. The mailbox word is 7. |
| `020b8d24` | `wait_channel` | Calls `register_channel(7, on_channel_7)`, then returns once `channel_ready(7, 1)` is true. That test is bit 7 of the word at `027fff8c`. Until then it calls `busy_wait(100)` and checks again. `return_zero` does not take the early exit. |
| `020b8d90` | `on_channel_7` | Turns interrupts off, passes its second argument to `dispatch_reply`, and restores the saved interrupt flag. The first argument is not read. |
| `020b8dc0` | `count_held` | Returns `256` minus the free-list length from `count_free` minus the queued-list length from `count_queued`. A positive result is records on neither list. |
| `020b8de0` | `count_queued` | Counts records on the queued list at `0214b2b0`. Follows each record's first word. An empty list returns 0. |
| `020b8e0c` | `count_free` | Counts records on the free list at `0214b2a8`. Follows each record's first word. An empty list returns 0. |
| `020b8e38` | `count_reached` | Compares the argument with the counter at `0214b2ac`. Returns true when the counter has reached that value. A gap of `0x80000000` or more is treated as the counter wrapping past it. |
| `020b8e74` | `read_count` | Returns the word at `0214b2ac` when the queue head at `0214b2b0` is 0. Otherwise returns the word at `0214b2c8`. |
| `020b8ea0` | `wait_count` | Returns when `count_reached` says the word at `0214b2ac` has reached the saved count. Otherwise reclaims with 0, tries again, calls `send_zero`, and then reclaims with 1 until the count has been reached. |
| `020b8f30` | `file_queue` | Calls `clean_lines` on `0214b580` for `0x1800` bytes, then `send_fifo(7, queue head, 0)`. A result of 0 or more files the queued list at `0214b2b0` into the next slot of the nine at `0214b2cc` and clears `0214b2b0` and `0214b2b4`. An empty queue returns 1. A filled-slot count at `0214b2c4` of 8 or more returns 0 when the argument is 0. |
| `020b9064` | `link_record` | Appends a record to the queue. Its first word is set to 0. An empty queue stores it at both `0214b2b0` and `0214b2b4`. Otherwise the old newest's first word points at it, and `0214b2b4` moves to it. |
| `020b9098` | `take_record` | Returns a free record. The first call is `pop_record`. A record from that pop is returned at `020b90c0`. An argument of 0 returns 0 when the list is empty. An argument of 1 calls `count_held`. A positive result loops `reclaim_list(0)` and tries `pop_record` again. If that fails, or the count was below 1, it calls `file_queue`, `send_zero`, then `reclaim_list(1)` until a record is available. |
| `020b9134` | `reclaim_list` | Moves one of nine lists at `0214b2cc` onto the free list. Argument 0 returns 0 when the word at `0214b2ac` matches `fresh_word`. The index at `0214b2bc` then advances and wraps after 8. |
| `020b9218` | `init_queue` | Calls `wait_channel`, then chains 256 records of `0x18` from `0214b580` onto the free list and clears the queue words. Takes one record, stores `0x19` at `+4` and `0214b300` at `+8`, and files that queue. |
| `020b9330` | `dispatch_reply` | The low byte of the message picks one of eight 12-byte records at `0214cd80`. The next byte must match the tag at `+8`. A matching record with a function at `+0` is called with the word at `+4`. `set_reply` stores that function and argument. |
| `020b9390` | `set_reply` | Stores a function and an argument into record `index × 12` at `0214cd80`, adds 1 to the tag byte, and returns the new tag. |
| `020b93c4` | `bump_tag` | Adds 1 to the tag byte at `+8` of reply record `index × 12` at `0214cd80`. The add is a byte, so 255 wraps to 0. The new tag is left in `r0`. |
| `020b9494` | `fresh_word` | Calls `invalidate_lines` on 0x280 bytes at the block pointed to by `0214cde0`, then returns that block's first word. |
| `020b94c8` | `second_word` | Same cache drop as `fresh_word` on the block at `0214cde0`, then returns the word at offset 4. `step_nodes` tests those bits. |
| `020b94fc` | `pack_level` | Clamps the argument to `-723` through `0`. Adds 723 and loads a byte from `0211c950`. Returns that byte with a band in the next 8 bits: 3 below `-240`, 2 below `-120`, 1 below `-60`, and 0 from `-60` through `0`. |
| `020b96a0` | `send_fifo` | Writes one word to the send mailbox at `0x04000188`. Low 5 bits are the first argument, bit 5 is the third argument, and the rest is the second argument shifted up by 6. Returns 0, or `-1` when bit 14 of `0x04000184` is set, or `-2` when bit 1 is set. |
| `020b9754` | `channel_ready` | Returns true when bit `1 << channel` is set in the word at `027ffc00 + index × 4 + 0x388`. Index 0 is `027fff88`. Index 1 is `027fff8c`. |
| `020b977c` | `register_channel` | Stores the handler at `0214cde8 + channel × 4`. A nonzero handler sets `1 << channel` in the word at `027fff88`. A handler of 0 clears that bit. Interrupts are off for the update. |
| `020b98f4` | `result_zero` | Returns 0. It is the entry for argument 8 in the table at `0211cc24`. |
| `020b99a0` | `build_path` | Entry 5 in the table at `0211cc24`. Finds a directory index with `step_up` and `read_name`, then writes a path into the buffer at `+0x2c`. The path starts with 1, 2, or 3 bytes from the parent and the two bytes `:/` at `021219d0`. Names are copied in from the end, with `/` between them. A missing index returns 1. A zero buffer at `+0x2c` returns 0. |
| `020b9d60` | `walk_path` | Entry 4 in the table at `0211cc24`. Walks the text at `+0x38`, split on `/` and `\`. `.` is skipped. `..` calls `step_up` when the halfword at `+0x20` is nonzero. Each other piece is found with `ask_parent(block, 3)` and compared by `match_name`. A piece longer than 127, an empty piece, or a failed read returns 1. |
| `020b9f7c` | `read_name` | Entry 3 in the table at `0211cc24`. Reads one byte through `pull_bytes`. The low 7 bits are a length at the record's `+0x10`, and the top bit is stored at `+0xc`. A length of 0 returns 1. Otherwise the following bytes are read into `+0x14` when the block's word at `+0x30` is 0, and a 0 byte is stored after them. |
| `020ba090` | `load_block` | Entry 2 in the table at `0211cc24`. Copies the three words at `+0x2c` onto `+0x1c`. Calls `pull_bytes` for 8 bytes at `parent + 0x28` plus the halfword at `+0x30` times 8. Stores the low 12 bits of one returned halfword at `+0x28`, and returns 0. |
| `020ba128` | `advance_next` | Entry 1 in the table at `0211cc24`. Same add as `advance_block`, then calls the function at the parent's `+0x40` with the parent, the word at `+0x2c`, and the old word at `+0x28`. |
| `020ba160` | `advance_block` | Entry 0 in that table. Adds the word at `+0x34` to the word at `+0x28`, then calls the function at the parent's `+0x3c` with the parent, the word at `+0x2c`, and the old word at `+0x28`. |
| `020ba198` | `match_name` | Compares two byte strings for the given length. `A` through `Z` are folded onto `a` through `z`. Returns 0 when every byte matches. A difference returns the gap between the folded bytes. A length of 0 or less returns 0. |
| `020ba1fc` | `step_up` | Sets bit 2 of the word at `+0xc`. Stores the parent at `+0x2c`, 0 at `+0x34` and `+0x32`, and the low halfword of the second argument at `+0x30`. Then calls `ask_parent(block, 2)`. |
| `020ba240` | `pull_bytes` | Sets bit 9 of the parent's word at `+0x10`, then calls the function at the parent's `+0x44` with the parent, the output buffer, the address, and the count. A result of 0 or 1 clears bit 9. A result of 6 calls `yield_heap(parent + 0xc)` until bit 9 is clear. The address then increases by the count. |
| `020ba2fc` | `ask_parent` | Sets bit 9 of the parent's word at `+0x10` when bit 2 of the block is set, otherwise bit 8. If bit `1 << argument` of the parent's word at `+0x4c` is clear, the result is 7 and the function at `0211cc24 + argument × 4` is called. Entry 0 of that table is `advance_block`. Entry 1 is `advance_next`. Entry 2 is `load_block`. Entry 3 is `read_name`. Entry 4 is `walk_path`. Entry 5 is `build_path`. Results 0, 1, and 4 are stored at the block's `+0x14`. |
| `020ba4a0` | `set_state` | Calls `detach_block` with the block in `r0`. Clears the low 4 bits of the word at `+0xc`, stores the result at `+0x14`, and calls `mark_heaps` with `block + 0x18`. |
| `020ba7dc` | `start_block` | Stores the second argument at `+0x10` and 2 at `+0x14`, and sets bit 0 of the word at `+0xc`. An argument from 2 through 8 also sets bit 2. The word at `+8` is the parent. Bit 7 of the parent's word at `+0x10` returns 0. Otherwise `append_block` links the block onto `parent + 0x14`, and the function returns 1 or the result of `run_block`. |
| `020ba944` | `run_block` | Calls `ask_parent` with the block and the word at `+0x10`, then `set_state` with the block and that result. A nonzero result from `scan_parent` on the parent calls `follow_head` with that result. Returns true when the word at `+0x14` is 0. |
| `020ba98c` | `follow_head` | Sets bit 3 of the block's word at `+0xc` and calls `ask_parent`. A result of 6 returns. Otherwise takes the next head from `scan_parent` on the same parent and repeats. Bit 2 of the block calls `mark_heaps` and returns. |
| `020baa2c` | `scan_parent` | Bit 5 of the word at `+0x10` walks the list at `+0x18` and calls `set_state(node, 3)` for each node with bit 1 set. If bit 3 is clear and a head exists, returns that head unless its bit 2 is set, in which case it calls `mark_heaps` and returns 0. Otherwise returns 0. |
| `020baf24` | `reset_block` | If `start_block` returns nonzero, stores 0 at `+8` and `0xc` at `+0x10`, and clears bits 4 and 5 of the word at `+0xc`. Returns 1. Otherwise returns 0. |
| `020bb238` | `blank_block` | Stores 0 at `+0`, `+4`, `+8`, `+0xc`, and the halfword at `+0x18`. Stores `0xc` at `+0x10`. `build_path` passes its scratch block. |
| `020bb29c` | `append_block` | Unlinks the block from its old neighbors, then links it after the last block reached by following `+4` from the second argument. The block's first word becomes that predecessor, and its word at `+4` becomes 0. |
| `020bb2e4` | `detach_block` | If the block's first word is set, that neighbor's word at `+4` is set to this block's next pointer. If the next pointer is set, that neighbor's first word is set to this block's previous pointer. Then both of this block's link words are stored as 0. |
| `020c0870` | `divide_signed` | Divides the first argument by the second. The quotient is the low half of the return and the remainder is the high half. A second argument of 0 returns the first argument and a remainder of 0. The branch at `020c08dc` enters an unrolled loop one bit at a time. |
| `020bc1d4` | `send_command` | Saves the interrupt mask, leaves only the IPC-receive bit set, and retries a send until it returns 0. `frame` calls it as `send_command(0xc, 0, 0)`. The `bxeq lr` at the end is a normal return. |
| `020bc338` | `read_bits` | Asks channel 8 for a halfword. Writes bit 3 of that halfword to `027c000c` and bit 2 to `027c0010`. A nonzero result from the read writes nothing. |
| `020bca74` | `on_channel_5` | Handler for channel 5. Returns when its third argument is greater than or equal to 0. |
| `020bc754` | `on_channel_8` | Handler for channel 8. Returns when its third argument is 0. Otherwise, if a function is stored at `0214cf34`, it calls that function and clears the pointer. |
| `020bc840` | `init_channel_8` | Runs once. Clears the two words at `0214cf30`, waits for channel 8, registers `on_channel_8`, clears the first halfword of four 8-byte records at `0214cf54`, and copies the word at `027ffc3c` to `0214cf2c`. |
| `020bd0e4` | `init_channel_5` | Runs once. Clears five words at `0214cf78`, waits until bit 5 is set at `027fff8c`, and registers `on_channel_5` at `0214cdfc`. |
| `020bd560` | `on_channel_11` | Handler for channel 11. Returns immediately unless the first argument is `0xb`. |
| `020bdacc` | `init_messages` | Runs the record setup once, then always registers channel 14. The record is `0214cfc0`: three zeros at `+0x18`, `+0x1c`, and `+0x20`, and `-1` at `+0x24`. |
| `020be368` | `on_channel_14` | Handler for channel 14. If the low 6 bits of the message are `0x11`, stores 1 at `0214d7e0`. |
| `020be714` | `on_channel_13` | Lasting handler for channel 13. If the low 6 bits of the message are `0x11`, calls the function pointer at `0214d7f4`. |
| `020be774` | `ack_channel_13` | Temporary handler for channel 13. If the low 6 bits of the message are 1, stores the halfword 1 at `0214d7e8`. |
| `020be96c` | `init_channel_13` | Runs once. Registers `ack_channel_13`, runs the cartridge setup, then replaces that handler with `on_channel_13` and clears `0214d7f4`. |
| `020bb330` | `register_rom` | Registers the device object at `0214ce94` under the name `rom`. Opening `"/"` uses that device. |
| `020bbda4` | `init_ipc` | Runs once. Calls the IPC handshake thunk, waits until `FUN_020b9754(6, 1)` returns nonzero, then passes `6` and the function at `020bbe34` to `FUN_020b977c`. |
| `020bb54c` | `restore_divider` | Writes the saved divider and square-root values back to `0x04000280`, `0x04000290`, `0x04000298`, `0x040002b0`, and `0x040002b8`. |
| `020bb5b8` | `save_divider` | Copies the hardware divider and square-root unit into the record. `save_context` calls it with the heap record plus `0x48`. |
| `020bdc98` | `read_card` | Reads bytes off the game card. The `rom` device uses it to pull a file out of `rom.bin`. |
| `02122a40` | `mix_samples` | Runs at `01ff8f80`. The byte at `0214869a` is the channel count. A count of 0 returns. Otherwise each live `0x18`-byte record at `02148c00` advances by its step times the sample count. Crossing the end pointer stops the channel or wraps it. `02122b0c` then jumps through the list just built, ending at `write_samples`. |
| `02122bbc` | `write_samples` | Runs at `01ff90fc`. Shifts eight values right by 8, clamps each to the range `-0x7f01` through `0x7f00`, and stores them as shorts. The first four go to the buffer in `r8`. The next four go `0x1000` bytes later. If `r8` is still below the end in `r9`, it jumps to the next handler. |
| `02122cbc` | `lerp_channel` | Runs at `01ff91fc`. Blends four pairs of signed bytes. The fraction in the low half of the position picks a point between a byte and the next one. The low half of the volume scales one side, and the high half scales the other. The results are added into `r0` through `r7`, then `02122d84` jumps to the next handler. |
| `02122d88` | `blend_bytes` | Runs at `01ff92c8`. Blends four signed bytes. The low half of the position is the step, and each sample adds that half into the high half. A carry moves the byte pointer an extra byte. The volume is in `r10`. `02122e34` jumps to the next handler. |
| `02122e38` | `blend_wrap` | Runs at `01ff9378`. Blends four signed bytes the same way as `lerp_channel`. After each one, the step is added to the position. If that result is zero or positive, the loop length is subtracted, shifted up by 16, until the position is negative again. `02122f44` jumps to the next handler. |
| `02122f4c` | `blend_rest` | Runs at `01ff948c`. Blends signed bytes the same way as `lerp_channel`, but only while the position stays negative. Adding the step in `r10` moves it toward zero. Once it reaches zero, the handler pointer is replaced with `02123030`, and the channel is skipped from then on. |
| `02123038` | `blend_shorts` | Runs at `01ff9578`. Same blend as `lerp_channel`, but each sample is a signed short. The top of the position picks the short, and the low 16 bits blend it with the next one. Four steps are added to the position, and `021230dc` jumps to the next handler. |
| `02123244` | `plain_bytes` | Runs at `01ff9784`. No blend. The signed byte at the position is the whole sample, scaled by the two volume halves. The position advances by the step four times. The third loaded byte is replaced by the next address before it is scaled. |
| `021224b0` | `run_slots` | Runs once for slot 0 and once for slot 1, then calls `update_slot`. The copy that `frame` calls is at `01ff89f0`. |
| `02123458` | `start_dma` | Turns interrupts off, writes a DMA channel's source, destination, and control word, then restores interrupts. Runs from the ITCM copy at `01ff9998`. The control word is stored last, and its top bit starts the copy. |

## ROM

Files live in `~/Downloads/Urbz/`.

| Piece | Role |
|---|---|
| `header.bin` | ROM header. ARM9 loads at `02000000`, entry `02000800`. No ARM9 overlays (`0x50` is zero). |
| `arm9.bin` | Main program, about 1.2 MB. Ghidra block ends at `02123683`. |
| `arm7.bin` | Helper CPU. Loaded at `02380000`, size `0x26494`. |
| `rom.bin` | Archive pulled from the card. `27,040,340` bytes. Device name is `rom`. |
| `SoundData.rom` | Separate archive. Not read yet. |

`rom.bin` starts with a directory of little-endian `u32` offsets. The first word is `0xD128`, and there are `0xD128 / 4 = 0x344A` words (`13386`). The last word, `0x019C9A54`, is the end of the file. Spans between adjacent words are the files, so there are `13385` files. File `n` (counting from 1) starts at word `n - 1` and ends at word `n`.

`tools/extract_rom.py` cuts one of those files out.

## Execution

`02000800` is startup. It turns interrupts off, sets up the caches, copies the ITCM block, clears memory, and jumps to main at `02000b00`. Main does its setup once, then repeats one call forever:

```c
do {
  frame();
} while (true);
```

Before that loop, `main` turns the hardware on and initializes subsystems. The subsystem calls are not opened one by one.

`0x04000304` is the power register. The mask `0xfdf1` and the value `0x020e` turn on 2D engine A, both 3D engines, and 2D engine B. `0x04000208` is the interrupt enable. It is set to 1 around `init_fs`, the filesystem setup already traced. The saved old value is passed in.

`027c0004` is the slot the frame saves. Setup stores 0, then calls `FUN_0208093c(0x3f, 0x10)` once with the slot set to 1 and once with it set to 0.

`027c0000` is the vblank count the frame waits for. Setup stores 2. `return_zero` is `mov r0, #0` and `bx lr`, so the branch that would store 1 never runs. The frame waits for two vertical blanks.

`load_boot_files` runs during that setup. It calls `load_boot_file(index, 0)` for indexes 0 through 7.

`load_boot_file` loads one `rom.bin` file and copies its header into a 0x14-byte record at `02140d60 + index * 0x28`. The second argument selects a second record 0x14 bytes later. Startup passes 0, so only the first record is filled. The file id is the word at `020c5cec + index * 8`. The byte stored at record `+6` is the low byte of the word 4 bytes after that id.

| Index | File | Byte at `+6` |
|---|---|---|
| 0 | 11548 | 8 |
| 1 | 11547 | 8 |
| 2 | 11550 | 0x10 |
| 3 | 11549 | 0x10 |
| 4 | 11551 | 0x10 |
| 5 | 11553 | 0x10 |
| 6 | 11552 | 0x10 |
| 7 | 11556 | 0x10 |

The loaded bytes are read as: ushort at `+0` into record `+2`, ushort at `+2` into record `+4`, byte at `+4` into record `+0`. Three big-endian ushorts at file `+6`, `+10`, and `+14` are added to the file pointer and stored at record `+8`, `+0xc`, and `+0x10`.

All eight boot files share that shape. Each first ushort is 32, and each has 32 increasing ushorts at `0x10`. The third section starts at `0x1e0` in seven of them and at `0x1e4` in file 11556.

File 11548 is 3824 bytes. Its list runs from `0` through `0x248`. The gap between one value and the next is a piece length. The last piece has no following value, so its length is not in the list. Adding the offsets to `0x1e0` (the third section) stays inside the file. Piece 0 is 14 zero bytes. Piece 1 is 9 bytes, `11 11 01 01 00 00 00 00 00`. The middle section at `0x144` is 156 bytes of small values and is separate from this list. The second header ushort, `0xb9`, is not yet tied to a count in the file. `attach_file(index, value, arg3)` attaches one loaded file to the current slot. The slot is the word at `027c0004`, and the `0x3c`-byte block for that slot starts at `02140ce8`. `index * 0x28` selects the file record at `02140d60`. The block stores that record pointer, the pointer `0x14` bytes later, and the byte at record `+6`. If the word at block `+0x28` is 1, `value` is stored whole and block `+0x10` is set to 0. Otherwise the low 4 bits of `value` are stored and the higher bits are shifted up by 12 into block `+0x10`. `arg3` is stored at block `+0xc`. The functions that mention the slot block `02140ce8` do not load file-record `+8`. The 32-piece list is still unread.

`copy_blocks` is not that reader. For the current slot it copies `param_2` blocks of words into `param_4`. The block size is the word at slot-block `+0x24`. It also writes `param_5` into a ushort at `param_3`, then steps `param_3` by `0x20` ushorts. If slot-block `+0x28` is 1, the ushort is only that index. If slot-block `+0xc` is -1, the index is combined with the old top 4 bits. Otherwise the index is combined with the low 16 bits of slot-block `+0x10`.

It then writes the slot at `027c0004` to 0 and to 1. For each slot it zeroes `0x3c` bytes at `02140ce8 + slot * 0x3c` through `zero_memory`. `02140ce8` is past the end of `arm9.bin`, so those records exist only at runtime.

`enable_screen_b` runs just before the frame loop. It calls `show_display_a`, then sets bit `0x10000` in `0x04001000`, the second screen's display control. Bit 16 selects the normal display mode.

`show_display_a` writes the first screen at `0x04000000`. The mask `0xfffcffff` clears bits 16 and 17. If the ushort at `0214af2c` is 0, it sets bit 16, which is mode 1, the normal picture. Otherwise it stores that ushort into those bits. `0214af2c` is past the end of `arm9.bin`, so the ushort exists only at runtime. It also stores 1 at `0212195c`. The file bytes there are already `01 00 00 00`, so the flag starts as 1.

`set_display_a(mode, bits, bg0_3d)` stores `mode` at `0214af2c` and writes `0x04000000`. The mask is `0xfff0fff0`. That keeps the old register except bits 0–3 and bits 16–19. Bits 16 and 17 come from `mode`. Bit 3 comes from the third argument shifted left by 3. `bits` supplies the rest, including bits 0–2. If the flag at `0212195c` is 0, `mode` is forced to 0. If the stored mode is 0, the flag is cleared.

`hide_display_a` stores 0 at `0212195c`, saves bits 16 and 17 of `0x04000000` into `0214af2c`, then clears those two bits with `0xfffcffff`. The first screen's picture is off until `show_display_a` runs. The only caller is `main` at `02000b3c`. Six calls run first: `FUN_02079d6c`, `FUN_020b7cb4`, `FUN_020bbda4`, `FUN_020b744c`, `do_nothing`, and `reset_display`. `init_heap` returns immediately if the word at `0214afb8` is already set, and otherwise sets that word to 1. The header it clears is the next word, `0214afbc`. The other record is `0214b0a4`, which is `0xe8` bytes after the header. All three are past the end of `arm9.bin`. It clears 16 words in the header and fills offsets in the other record, including `+0x64` (the decompiler's `+ 100` is decimal). It then calls `set_heap_word(0)`, which clears the header word at `+0x10` (`0214afcc`), and `add_heap`. The call passes the record `0214b010`, the code address `020b6fec`, `0`, and the end address `0214b200`. The next two arguments are on the stack: the size `0xc8`, and `0x1f`. `add_heap` stores `0x1f` at the record's `+0x70`, and `init_heap` then overwrites that field with `0x20` and sets `+0x64` to 1. The start of that range is `0214b200 - 0xc8`, which is `0214b138`. The same markers, `0x7bf9dd5b` and `0xfddb597d`, are written at the start and just before the end. `fill_heap_head` then stores `020b6ff0` at the record's `+0x40`, the end marker address at `+0x44`, and that address minus `0x40` at `+0x38`. `020b6fec` is the start of a function, and `020b6ff0` is its next instruction. The pointer is even, so the record's first word is `0x1f`. `fill_words` writes 0 through the `0xc0` bytes between those markers. The pointer steps by one word, and the third argument is the byte count. `add_heap` stores `release_heap` at the record's `+0x3c`. `release_heap` turns interrupts off and does not call `restore_irq`. The word at `0214afb4` is `0214afc4`, which is header `+8`, and that word holds the heap record. It clears that record's slot in the table at `0214afd0` and sets `+0x64` to 2. Before that, `drain_heap` returns immediately when the record's `+0x7c` is 0, which is how `add_heap` leaves it. When `+0x7c` is not 0, `pop_heap_node` returns the first node. The node's `+0x10` is the next node, and that next node's `+0xc` is cleared. An empty list also clears the heap record's `+0x80`. `drain_heap` then stores 0 at the node's `+4` and `+8`, and calls `mark_heaps` with the node still in `r0`. The decompiler shows that call with no argument. `mark_heaps` reads the first ushort. With interrupts off, it walks the heap list at `0214afbc + 0xc`. The next heap is `+0x68`. If bit `1 << slot` is set, using the slot at that heap's `+0x6c`, it sets that heap's `+0x64` to 1. Then it clears the ushort and calls `switch_heap`. A zero ushort skips the walk. `switch_heap` reads the CPU mode with `mrs` and keeps the low 5 bits. `0x12` is interrupt mode. In that mode, or when the ushort at header `+4` is already nonzero, it sets the ushort at header `+0` to 1 and returns. Otherwise it loads the current heap through `0214afb4`, which points at header `+8`. It compares that heap with `find_marked_heap`, which returns the first heap in the list whose `+0x64` is 1, or 0. The list base in its pool is `0214afbc`. `save_context` then stores the status register at the start of the current heap record, switches to supervisor mode (`0xd3`, interrupts off) long enough to store that mode's stack pointer at `+0x44`, switches back, and stores the general registers and the return address. It returns 0. `restore_context` loads that saved state from the new heap. It calls `restore_divider` first. The pool word at `020b779c` is `020bb54c`. Then it switches to supervisor mode, copies the saved status into the saved-status register, loads the saved stack and the general registers, and executes `subs pc, lr, #4`. That one instruction restores the status register and jumps to the saved return address minus 4. An optional call lives at `0214afb0`. Another optional call is the word at header `+0x10`, the same word `set_heap_word` writes. Both start out empty. The record is stored in the 16-word table at `0214afd0`, which is the header plus `0x14`. `insert_heap` then links that record into the list whose head is the pointer at `0214afbc + 0xc`. The link to the next record is `+0x68`. The list stays ordered by the unsigned word at `+0x70`, smaller values first. The slot number comes from `find_heap_slot`. That function checks 16 words at `0214afbc + 0x14` and returns the index of the first 0, or `-1` when all 16 are full. `DAT_020b759c` is 0, so the start address is `027c01a0`. The end address is `027c0000 + 0x3fc0 - 0x800`, which is `027c37c0`. `027c01a0` is the first byte after the `0x1a0` bytes `startup` copies to `027c0000`. Those two addresses are stored at the record's `+0x84` and `+0x88`. The word at the start, `027c01a0`, is set to `0x7bf9dd5b`. The word just before the end, `027c37bc`, is set to `0xfddb597d`. Those are boundary markers. The call after that is `FUN_020b7000(0)`. The zero is the value left in `r0` by the stores just above the call. With interrupts off, it replaces the word at `DAT_020b7030 + 0x10` with that argument and returns the old word. `init_heap` ignores the returned word. `DAT_020b7030` is not read yet. `do_nothing` returns immediately. `FUN_020b5ffc` writes `0x04000304` before `main` does. It sets bit 15, then applies the same mask `0xfdf1` and value `0x020e`, then sets bit 0. Bit 0 turns both screens on. Bit 15 swaps which screen each engine uses. It calls `FUN_020b6158`. That stores 0 into 13 ushorts at `0214af30`, which is RAM just after the saved mode at `0214af2c` and is past the end of `arm9.bin`. It also stores 0 at `0x04000240` through `0x04000246` and at `0x04000248`. Those are the VRAM bank controls. A 0 disables the bank. `0x04000247`, the shared-memory control, is skipped. Then it stores 0 at `0x04000004`, then stores 0 in `0x04000000`, so the whole first-screen display register is cleared before `hide_display_a` saves bits 16 and 17. The branch reads the word at `02121960`, four bytes after the flag at `0212195c`. The file bytes there are `03 00 00 00`, so the value is 3, not -1. Boot takes the second branch and calls `dma_fill` twice. The first argument is 3 and the third is 0. The first call writes `0x60` bytes at `0x04000008`, engine A's background registers. Between the calls, `0x0400006c` is set to 0. That is engine A's master brightness. The second call writes `0x70` bytes at `0x04001000`, engine B's display registers. `dma_fill` returns immediately when the size is 0. Otherwise it waits while bit 31 of the DMA control word is set, stores the third argument into that channel's fill word, and calls the ITCM function at `01ff9998` with the size shifted right by 2 combined with `0x85000000`. It waits on bit 31 again. The DMA registers start at `0x040000b0`. The fill words start at `0x040000e0`. Channel 3's control word is `0x040000dc` and its fill word is `0x040000ec`. `0x85000000` enables the transfer, uses 32-bit words, and keeps the source address fixed, so every word written is the fill value. Do not click `func_0x01ff9998`. Its bytes are in the file at `02123458`, and that is where it runs from after the ITCM copy: `01ff9998`. Ghidra had left those bytes as data. `start_dma` stores the source, destination, and control word at `0x040000b0 + channel * 3`. That is the DMA register block. Channel 3 starts at `0x040000d4`. The control word is stored last, and its top bit starts the DMA. `disable_irq` and `restore_irq` wrap those three stores. Ghidra names those calls `func_0x021e1cfc` and `func_0x021e1d10` because it still has the bytes at their file address. It also writes `0x100` to the size registers for background 2 and background 3 on both screens: `0x04000020`, `0x04000026`, `0x04000030`, `0x04000036`, and the same offsets from `0x04001000`. `0x100` is normal size. The other two numbers in each size pair stay 0, so the picture is not rotated. Then `main` updates `0x04000304`, the graphics power register. The mask is `0xfdf1` and the value is `0x020e`. The mask clears bits 1, 2, 3, and 9, and the value sets those bits: 2D engine A, both 3D engines, and 2D engine B. Then `main` calls `hide_display_a`. `show_display_a` runs later, from `enable_screen_b`, just before the `frame` loop.

`frame` (`02000ce0`) is the frame function. The names given in Ghidra are in the table at the top.

It saves the word at `027c0004`, which is the slot `update_slot` reads, and writes that word back at the end. If bit 15 of the word at `027fffa8` is set, it calls `mark_once`, `send_command(0xc, 0, 0)`, and `reset_buffer` first.

It then calls the ITCM function at `01ff89f0`. Those bytes are in the file at `021224b0`, where Ghidra names the function `run_slots`. The code runs `0x129ac0` bytes lower than that file address. Ghidra's `func_0x0212fce4` is that shift applied to `update_slot`: `0212fce4 - 0x129ac0 = 02006224`.

`run_slots` runs its body twice, with the slot at `027c0004` set to 0 and then 1. On slot 0 it calls `read_input` first, then `slot_pending` for both slots. A 0 return skips ahead to `record_changed`. An equal pair skips ahead to `call_entry`. Per slot it checks bytes at `027c006c` and `027c0064` and bits in the word at `027c0008`. On the second pass, when the byte at `027c006c` is 1, it sets that byte to 3 and copies 11 words inside the `0x8c`-byte record at `027c0070 + slot * 0x8c`. Then it calls `update_slot`. The other `func_0x021…` names in that listing are the same shift and are not read yet.

After that it calls `wait_vblank` until a counter has moved far enough. `wait_vblank` is Thumb `swi 5`, which waits for the next vertical blank. The counter struct is the pointer stored at `027c0020`. `set_frame_counter` stores `027c0028` there, so the new count is at `027c0044` (`+0x1c`) and the accepted count is at `027c0048` (`+0x20`). The loop continues while `+0x1c - +0x20` is less than the word at `027c0000`. Then `+0x20` is set equal to `+0x1c`. The word at `027c0000` is filled after boot, so its value is not in `arm9.bin`.

`unpack` walks backward through bytes. `startup` calls it once, with a null pointer, and it returns immediately. Nothing else calls it.

ITCM copy: source `02121ac0` (file offset `0x121ac0`), destination `01ff8000`, length `0x1a00`. A branch in that block is at file address `021226c8`. It runs at `01ff8c08` and calls `update_slot`. Ghidra shows the target as `0212fce4` only while the bytes are still at their file address.

ARM9 also copies `0x1a0` bytes from file offset `0x1234c0` to `027c0000`. Startup then clears `0x4000` bytes at `027c0000`. The ARM7 later copies `0x14948` bytes to the same address from its own image.

ARM7 entry and load address are both `02380000`. Its stub copies the real program to `037f8000` (length `0x119cc`) and another block to `027c0000` (length `0x14948`), then jumps to `037f8300`.

## Frame and objects

`update_slot` reads a slot number from the word at `027c0004`, marks a flag byte, and calls `update_objects` with an 8-byte pair of list heads.

`update_objects` walks those linked lists and updates each object. When its second argument is `1`, it also draws. It calls back into ITCM at `01ff8000` and `01ff849c`.

`UrbzObject` is imported in Ghidra. In `update_objects`, `cur` is the object walking `*param_1` in the first branch, and the struct type is applied there. `node` is the same kind of object in the other branch. The name stuck. The type did not, because `node + 0x20` on that branch is byte offset `0x80`, and Ghidra will not treat `node` as an `UrbzObject` pointer while that add remains. `node[3]` is still `flags`, `node[6]` is `pos_a_x`, and `node[8]` is `pos_b_x`.

The `cur` loop copies a position from the object pointer at `cur + 0x58` into `pos_b`. Bit 4 of `extra_flags` adds one pixel to Y, and bit 8 subtracts one. Then `pos_b` is copied into `pos_a`, and `wobble` runs. `0x58` is still inside `gap_50` in the header.

`wobble` adds a wobble to `pos_b`. Six shorts live in the gap at `+0x40`:

| Offset | Role |
|---|---|
| `+0x40` | X angle. The high byte is the lookup index. |
| `+0x44` | Added to the X angle each call. Zero skips X. |
| `+0x48` | Multiplies the X lookup. Result is added to `pos_b_x`. |
| `+0x42` | Y angle. |
| `+0x46` | Added to the Y angle each call. Zero skips Y. |
| `+0x4a` | Multiplies the Y lookup. Result is added to `pos_b_y`. |

X calls `cosine`. Y calls `sine`. Both are passed `(angle >> 8) & 0xff`.

`cosine` does not contain the table. It jumps through the pointer at `DAT_0204da40`, and it passes `index + 0x40` (`'@'` is the byte `0x40`). On a 256-step circle, `0x40` is a quarter turn. The bytes at `DAT_0204da40` are `44 da 04 02`, which is `sine`. Y already calls `sine` directly, so X is the same wave shifted by one quarter.

`sine` is the lookup. The index is a byte, so a full turn is 256 steps. `index >> 6` picks the quarter. Quarters 1 and 3 mirror the index with `(0x80 - index) & 0xff`. Quarters 2 and 3 negate the result. The stored quarter is `int`s reached through `DAT_0204da78`. Those bytes are `70 a7 0c 02`, so the table is at `020ca770`, indexed up through `0x40`. The first byte there is `00`, so angle 0 is 0. The dword at index `0x40` (`020ca870`) is `0x10000`, one pixel. The short at `+0x48` is the X amplitude in pixels, and `+0x4a` is the Y amplitude. Equal amplitudes and equal speeds make the object move in a circle, because X is one quarter turn ahead of Y.

The calls at `+0x4c` and `+0x5c` are per object, so the `node` loop has no single function to open. One writer of `+0x4c` is the instruction at `02006638`: it loads `02006548` and stores it there.

`follow_link` reads the byte at `+0x104` and the object pointer at `+0x11c`. The `+ 10` in the decompiler is decimal, so that short is at `+0x0a`. Bit 2 of `flags` is the bit the object loop tests before the normal update. Bit `0x400000` is the animation-finished bit.

- Byte `+0x104 == 1` sets flags bit 2 and returns. Any other non-zero value returns without changing flags.
- If the object at `+0x11c` has byte `+0x104 == 1`, or its flags bit 2 is set, call `set_mode(object, 1)` and return.
- A non-zero short at `+0x0a` returns.
- If the linked object's flags do not include `0x400000`, return.
- Otherwise call `call_run_bytes(object)`, then `set_mode(object, 1)`.

`set_mode(object, mode)` writes `mode` into the byte at `+0x104` when it differs from the current byte. It then sets bit 0 of the byte at `+0x106` and clears the byte at `+0x105`. The offset `0x106` is the word at `DAT_02000e50` (`06 01 00 00`). Calling it with `1` is what makes `follow_link` set flags bit 2 on the next visit.

`call_run_bytes` jumps through `DAT_02006544`. That word is `90 26 01 02`, so the target is `run_bytes`. The two arguments are the bytes at object `+0x120` and `+0x121`.

`run_bytes` runs each byte through `check_byte`. The decompiler shows the first call with no argument. The instruction before that `bl` does not change `r0`, and `r0` still holds the first byte, so the call is `check_byte` of that byte. A non-zero result sends the first byte to `spawn` and the second byte to `run_commands`.

`check_byte` returns 0 when the byte is 0, and the caller then skips it. It also returns 0 when the byte is 1 and bit 0 is set in the word at `DAT_0201254c`. That word is `0212279c`. Any other non-zero byte returns 1.

`spawn` creates objects for the byte at `+0x120`. `*DAT_02012684` is the table base. That pointer lives at `021227ac` and is filled at runtime. The byte indexes a ushort at `base + id * 2 + 2`. That ushort is the record offset. The record's first byte is a count. Each following ushort is an entry offset. The first word of an entry is the spawned object, and a 0 means it has not been created yet.

Creation calls the function at `DAT_0201268c + (entry word at +8, low 16 bits) * 4`. `DAT_0201268c` is `020c2308`, a list of function pointers. The first three words there are `0`, `0203294c`, and `020307a8`. On a new object the byte at `+0x10` becomes the id, the byte at `+0x11` becomes the entry index, flags bit `0x80000000` is set, and a null `+0x5c` is filled with `DAT_02012688`, which is `sort_point`.

`sort_point` writes the four shorts the draw sort reads. `>> 0x10` turns `pos_a` into a pixel. `param_1 + 100` is decimal, so that short is at `+0x64`.

- Flags bit `0x40000` clear: `+0x60` and `+0x64` are 0. `+0x62` and `+0x66` are the pixel Y.
- Bit `0x40000` set: the pixel point is passed to `FUN_020b0a10`, which writes `+0x60` and `+0x62`. Those two shorts are then copied to `+0x64` and `+0x66`. The first argument is the pointer at `02141fe4`.

`run_commands` runs the byte at `+0x121` as a packed list. `*DAT_020125b0` is the table base. That pointer lives at `021227a8`. The byte selects a record the same way as the spawn table: a ushort at `base + id * 2 + 2`. The id is also stored at `02122798`.

Each entry starts with a word. A 0 ends the list. Any other word is an index into the function list at `020c297c` and into the stride bytes at `020c3c5c`. The handler is called with the entry pointer, then the walk steps forward by that stride. The first strides are 4, 8, 8, 8, 8, 4, 4, 8. Index 0 is the end marker and its stride is 4. Index 1's function is `cmd_set_mode`.

`cmd_set_mode` reads the bytes at entry `+4` and `+5` and passes them to `lookup_spawn`. The entry stride is 8. If that call returns an object, `set_mode(object, 1)` sets its `+0x104` byte to 1, and flags bit `0x8` is set.

`lookup_spawn(group, slot)` returns the object pointer saved by the spawn. `DAT_020124a8` is `021227ac`, the same runtime pointer as the spawn table. `group` selects the record, and `slot` selects the entry, matching `spawn`. The exception is `group == 0` and `slot >= 0xff`: that reads a 16-byte record from `02141c2c` instead. For slot `0xff` the index is 0.

`cmd_set_value` is handler 2. It looks up the object the same way, from entry bytes `+4` and `+5`. The short at entry `+6` goes through `clamp_positive`, and the result is stored at object `+0x14`. A negative short becomes 0. A positive short is kept. The constant in that helper is `0x007fffff`, which does not change a positive short. Then bit `0x8` is set on the byte at `+0x106`. `DAT_02022b88` is the word `0x106`, the same byte `set_mode` uses for bit `0x1`.

`cmd_set_flag` is handler 3. Same lookup from entry `+4` and `+5`. It then calls `apply_flag(object, byte at +6, byte at +7)`.

`apply_flag` uses the first of those bytes as an operation and the second as on or off. `1` sets the bit. Any other value clears it. `set_flags` sets bits in `flags`. `clear_flags` clears them. Both add `0xc` to the object pointer before the load.

| Operation | Effect |
|---|---|
| `0` | Nothing. |
| `1` | `flags` bit `0x1`. |
| `2` | `flags` bit `0x4`. |
| `3` | `flags` bit `0x4000000`. |
| `4` | `extra_flags` bit `0x20`, the byte at `+0xc5`. |

`on_screen` tests one object against a 256 by 192 screen. Overlap sets flag bit `0x1000`. The selected view also sets bit `0x40000000`.

`update_anim` advances the animation and writes the frame rectangle into the edge fields. A delay byte at `+0x94` counts down first. A null script pointer at `+0xa0` means a plain frame loop. Otherwise `+0xa0` is a script of 2-byte commands. A command byte below `0xf1` is a frame number. `0xfb` and `0xfc` add a signed pixel offset, in `0x10000` units, to Y and X. `0xff` marks the animation finished.

## Files from `rom`

Animation ids below `0x344A` are file numbers. `load_file` loads one file. `lookup_file` returns the cached pointer, or the id unchanged when the id is already that large.

The directory read of `0xD128` bytes is placed at `0212352c`. That is past the end of `arm9.bin`. The tables after it are filled at runtime:

| Address | Contents |
|---|---|
| `0212352c` | Directory, `0xD128` bytes. Ends at `02130654`. |
| `02130654` | One loaded pointer per file. |
| `0213d77c` | One status byte per file. |

File `n` uses entry `n - 1`. Start word at `0212352c + (n - 1) * 4`, end word at the next address, pointer at `02130654 + (n - 1) * 4`.

The card reader is `read_card`. The device object is `0214ce94`, registered under the name `rom` by `register_rom`. Opening the path `"/"` uses that device.

## Object fields

See `include/urbz_object.h`. Offsets there were read from the functions above. Gaps are unnamed on purpose.

## Not mapped

Character behavior, missions, dialogue, menus, `SoundData.rom`, and the bytes inside a loaded animation file beyond the fields the player reads. The function pointers at object `+0x4c` and `+0x5c` are per object type.
