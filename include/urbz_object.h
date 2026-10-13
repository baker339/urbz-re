/* Object walked by FUN_02003a40.
 * Offsets come from on_screen and update_anim.
 * Import into Ghidra as a data type, then apply it to the object pointer.
 * Gaps are bytes those functions never read. Do not invent names for them.
 */
struct UrbzObject {
    unsigned int  next;             /* +0x00 */
    unsigned char gap_04[8];
    unsigned int  flags;            /* +0x0c */
    unsigned char gap_10[8];
    int           pos_a_x;          /* +0x18  fixed point, pixel in the high half */
    int           pos_a_y;          /* +0x1c */
    int           pos_b_x;          /* +0x20 */
    int           pos_b_y;          /* +0x24 */
    unsigned char gap_28[0x18];
    short         angle_x;          /* +0x40  high byte is the sine index */
    short         angle_y;          /* +0x42 */
    short         angle_speed_x;    /* +0x44  zero skips the X wobble */
    short         angle_speed_y;    /* +0x46 */
    short         amplitude_x;      /* +0x48  peak shift, in pixels */
    short         amplitude_y;      /* +0x4a */
    unsigned int  fn_4c;            /* +0x4c */
    unsigned char gap_50[0xc];
    unsigned int  fn_5c;            /* +0x5c */
    unsigned char gap_60[0xb];
    unsigned char piece_count;      /* +0x6b */
    unsigned char pieces[12];       /* +0x6c  two 6-byte pieces */
    short         edge_left;        /* +0x78 */
    short         edge_right;       /* +0x7a */
    short         edge_top;         /* +0x7c */
    short         edge_bottom;      /* +0x7e */
    unsigned char gap_80[0xc];
    unsigned int  flip;             /* +0x8c  sign bits flip X and Y */
    unsigned char gap_90[4];
    unsigned char delay;            /* +0x94  counts down to 0 */
    unsigned char delay_reload;     /* +0x95 */
    unsigned char frame_shown;      /* +0x96 */
    unsigned char frame;            /* +0x97 */
    unsigned char gap_98[4];
    unsigned int  anim_ref;         /* +0x9c  word at +4 is the lookup id */
    unsigned int  script;           /* +0xa0  null means a plain frame loop */
    int           script_index;     /* +0xa4 */
    int           script_base;      /* +0xa8 */
    unsigned char gap_ac[0x18];
    unsigned char force_visible;    /* +0xc4  1 skips the screen test */
    unsigned char extra_flags;      /* +0xc5 */
};

/* flags at +0x0c that the screen test and animation player touch */
enum {
    URBZ_FLAG_ACTIVE        = 0x00000010,
    URBZ_FLAG_FRAME_CHANGED = 0x00000080,
    URBZ_FLAG_ON_SCREEN     = 0x00001000,
    URBZ_FLAG_SKIP_CULL     = 0x00200000,
    URBZ_FLAG_ANIM_DONE     = 0x00400000,
    URBZ_FLAG_ON_SELECTED   = 0x40000000
};
