    .include "macros/function.inc"

    .text
    .global func_01ff8000
    arm_func_start func_01ff8000
func_01ff8000: ; 0x01ff8000
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    sub sp, sp, #0x24
    str r0, [sp, #0x0]
    subs r0, r0, #0x1
    mov r0, #0x0
    str r1, [sp, #0x4]
    str r0, [sp, #0xc]
    addeq sp, sp, #0x24
    ldmeqia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bxeq lr
    str r0, [sp, #0x1c]
    str r0, [sp, #0x18]
    mov r0, #0x1
    str r0, [sp, #0x20]
.L_01ff8038:
    ldr r1, [sp, #0x4]
    ldr r0, [sp, #0xc]
    ldr r6, [sp, #0x18]
    ldr r10, [r1, r0, lsl #0x2]
    ldrb r0, [r10, #0x6b]
    cmp r0, #0x0
    bls .L_01ff8284
    ldr r0, [sp, #0xc]
    add r0, r0, #0x1
    str r0, [sp, #0x14]
.L_01ff8060:
    mov r0, #0x6
    mla r1, r6, r0, r10
    ldrsb r0, [r1, #0x70]
    cmp r0, #0x0
    beq .L_01ff8270
    ldrh r2, [r1, #0x6c]
    ldrsh r0, [r1, #0x6e]
    ldr r4, [r10, #0x24]
    ldr r1, [r10, #0x8c]
    add r0, r2, r0, lsl #0x10
    mov r2, r1, lsl #0x3
    ldr r3, [r10, #0x20]
    mov r4, r4, asr #0x10
    mov r1, r0, lsl #0x8
    add r11, r4, r1, asr #0x18
    add r1, r4, r0, asr #0x18
    str r1, [sp, #0x8]
    mov r1, r2, lsr #0x1f
    cmp r1, #0x1
    moveq r1, r0, lsl #0x10
    mov r3, r3, asr #0x10
    moveq r0, r0, lsl #0x18
    subeq r7, r3, r1, asr #0x18
    subeq r8, r3, r0, asr #0x18
    movne r1, r0, lsl #0x10
    movne r0, r0, lsl #0x18
    addne r7, r3, r0, asr #0x18
    ldr r0, [sp, #0x14]
    addne r8, r3, r1, asr #0x18
    and r1, r0, #0xff
    ldr r0, [sp, #0x0]
    str r1, [sp, #0x10]
    cmp r1, r0
    bhs .L_01ff8264
.L_01ff80e8:
    ldr r1, [sp, #0x4]
    ldr r0, [sp, #0x10]
    ldr r9, [r1, r0, lsl #0x2]
    ldr r2, [r9, #0xc]
    ands r0, r2, #0x400
    beq .L_01ff8108
    cmp r6, #0x0
    bne .L_01ff8248
.L_01ff8108:
    ldr r0, [r10, #0xc]
    ands r1, r0, #0x20000
    beq .L_01ff811c
    ands r1, r2, #0x20000
    bne .L_01ff8240
.L_01ff811c:
    ands r1, r2, #0x4
    beq .L_01ff8240
    ldrb r1, [r9, #0x6b]
    ldr r4, [sp, #0x1c]
    mov r5, r4
    cmp r1, #0x0
    bls .L_01ff8240
.L_01ff8138:
    mov r0, #0x6
    mla r1, r5, r0, r9
    ldrsb r0, [r1, #0x70]
    cmp r0, #0x0
    beq .L_01ff820c
    ldrh r3, [r1, #0x6c]
    ldrsh r1, [r1, #0x6e]
    ldr r2, [r9, #0x24]
    ldr r0, [r9, #0x20]
    add r1, r3, r1, lsl #0x10
    mov r2, r2, asr #0x10
    mov ip, r1, lsl #0x8
    add r3, r2, r1, asr #0x18
    add lr, r2, ip, asr #0x18
    ldr r2, [r9, #0x8c]
    mov r0, r0, asr #0x10
    mov r2, r2, lsl #0x3
    mov r2, r2, lsr #0x1f
    cmp r2, #0x1
    moveq r2, r1, lsl #0x10
    moveq r1, r1, lsl #0x18
    subeq ip, r0, r2, asr #0x18
    subeq r2, r0, r1, asr #0x18
    movne r2, r1, lsl #0x10
    movne r1, r1, lsl #0x18
    addne ip, r0, r1, asr #0x18
    addne r2, r0, r2, asr #0x18
    cmp r8, ip
    blt .L_01ff820c
    cmp r7, r2
    bgt .L_01ff820c
    cmp r11, r3
    bgt .L_01ff820c
    ldr r0, [sp, #0x8]
    cmp r0, lr
    blt .L_01ff820c
    add r0, r10, r6, lsl #0x2
    ldr r2, [r0, #0x84]
    cmp r2, #0x0
    beq .L_01ff81f0
    cmp r4, #0x1
    beq .L_01ff81f0
    mov r0, r10
    mov r1, r9
    blx r2
    ldr r4, [sp, #0x20]
.L_01ff81f0:
    add r0, r9, r5, lsl #0x2
    ldr r2, [r0, #0x84]
    cmp r2, #0x0
    beq .L_01ff820c
    mov r0, r9
    mov r1, r10
    blx r2
.L_01ff820c:
    ldr r0, [r10, #0xc]
    ands r1, r0, #0x4
    beq .L_01ff8240
    ldr r1, [r9, #0xc]
    ands r1, r1, #0x4
    beq .L_01ff8240
    ands r1, r0, #0x400
    bne .L_01ff8240
    add r1, r5, #0x1
    and r5, r1, #0xff
    ldrb r1, [r9, #0x6b]
    cmp r5, r1
    blo .L_01ff8138
.L_01ff8240:
    ands r0, r0, #0x4
    beq .L_01ff8264
.L_01ff8248:
    ldr r0, [sp, #0x10]
    add r0, r0, #0x1
    and r1, r0, #0xff
    ldr r0, [sp, #0x0]
    str r1, [sp, #0x10]
    cmp r1, r0
    blo .L_01ff80e8
.L_01ff8264:
    ldr r0, [r10, #0xc]
    ands r0, r0, #0x4
    beq .L_01ff8284
.L_01ff8270:
    ldrb r0, [r10, #0x6b]
    add r1, r6, #0x1
    and r6, r1, #0xff
    cmp r6, r0
    blo .L_01ff8060
.L_01ff8284:
    ldr r0, [sp, #0xc]
    add r0, r0, #0x1
    and r0, r0, #0xff
    str r0, [sp, #0xc]
    ldr r0, [sp, #0x0]
    sub r1, r0, #0x1
    ldr r0, [sp, #0xc]
    cmp r0, r1
    blo .L_01ff8038
    add sp, sp, #0x24
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bx lr
    arm_func_end func_01ff8000

    .global func_01ff82b4
    arm_func_start func_01ff82b4
func_01ff82b4: ; 0x01ff82b4
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, lr}
    ldrb lr, [r0], #0x1
    mov r4, #0x0
    mov r8, r1
    mov r5, r4
    cmp lr, #0x0
    beq .L_01ff8484
    mov r9, r4
    mov r3, r4
    mov ip, #0x1
.L_01ff82dc:
    ands r6, lr, #0x80
    beq .L_01ff83a0
    ldrb r7, [r0], #0x1
    and r6, lr, #0x7f
    mov r10, r6, lsl #0x3
    and r6, r7, #0x1f
    and r7, r7, #0xe0
    add r6, r6, #0x2
    orr r10, r10, r7, asr #0x5
    cmp r6, #0x2
    addeq r7, r10, #0x42
    beq .L_01ff83b0
    add r7, r1, r5
    sub r7, r7, r10
    ands r10, r7, #0x1
    beq .L_01ff8334
    ldrb r10, [r7], #0x1
    eors r5, r5, #0x1
    sub r6, r6, #0x1
    movne r4, r10
    orreq r4, r4, r10, lsl #0x8
    streqh r4, [r1], #0x2
.L_01ff8334:
    cmp r5, #0x0
    mov lr, r6, lsr #0x1
    bne .L_01ff8368
    cmp lr, #0x0
    beq .L_01ff8358
.L_01ff8348:
    ldrh r10, [r7], #0x2
    subs lr, lr, #0x1
    strh r10, [r1], #0x2
    bne .L_01ff8348
.L_01ff8358:
    ands r6, r6, #0x1
    movne r5, ip
    ldrneb r4, [r7, #0x0]
    b .L_01ff8478
.L_01ff8368:
    cmp lr, #0x0
    beq .L_01ff8388
.L_01ff8370:
    ldrh r10, [r7], #0x2
    subs lr, lr, #0x1
    orr r4, r4, r10, lsl #0x8
    strh r4, [r1], #0x2
    mov r4, r10, lsr #0x8
    bne .L_01ff8370
.L_01ff8388:
    ands r6, r6, #0x1
    ldrneb r6, [r7, #0x0]
    movne r5, r3
    orrne r4, r4, r6, lsl #0x8
    strneh r4, [r1], #0x2
    b .L_01ff8478
.L_01ff83a0:
    ands r6, lr, #0x40
    beq .L_01ff83f0
    and r6, lr, #0x3f
    add r7, r6, #0x3
.L_01ff83b0:
    cmp r5, #0x0
    ldrb r5, [r0], #0x1
    subne r7, r7, #0x1
    orrne r4, r4, r5, lsl #0x8
    strneh r4, [r1], #0x2
    orr r4, r5, r5, lsl #0x8
    movs r6, r7, lsr #0x1
    beq .L_01ff83e4
    mov r5, r4, lsl #0x10
    mov r5, r5, lsr #0x10
.L_01ff83d8:
    strh r5, [r1], #0x2
    subs r6, r6, #0x1
    bne .L_01ff83d8
.L_01ff83e4:
    ands r5, r7, #0x1
    andne r4, r4, #0xff
    b .L_01ff8478
.L_01ff83f0:
    ands r6, r0, #0x1
    beq .L_01ff8410
    eors r5, r5, #0x1
    ldrneb r4, [r0], #0x1
    ldreqb r6, [r0], #0x1
    sub lr, lr, #0x1
    orreq r4, r4, r6, lsl #0x8
    streqh r4, [r1], #0x2
.L_01ff8410:
    cmp r5, #0x0
    mov r7, lr, lsr #0x1
    bne .L_01ff8444
    cmp r7, #0x0
    beq .L_01ff8434
.L_01ff8424:
    ldrh r6, [r0], #0x2
    subs r7, r7, #0x1
    strh r6, [r1], #0x2
    bne .L_01ff8424
.L_01ff8434:
    ands r6, lr, #0x1
    movne r5, ip
    ldrneb r4, [r0], #0x1
    b .L_01ff8478
.L_01ff8444:
    cmp r7, #0x0
    beq .L_01ff8464
.L_01ff844c:
    ldrh r6, [r0], #0x2
    subs r7, r7, #0x1
    orr r4, r4, r6, lsl #0x8
    strh r4, [r1], #0x2
    mov r4, r6, lsr #0x8
    bne .L_01ff844c
.L_01ff8464:
    ands r6, lr, #0x1
    ldrneb r6, [r0], #0x1
    movne r5, r9
    orrne r4, r4, r6, lsl #0x8
    strneh r4, [r1], #0x2
.L_01ff8478:
    ldrb lr, [r0], #0x1
    cmp lr, #0x0
    bne .L_01ff82dc
.L_01ff8484:
    cmp r5, #0x0
    strneb r4, [r1], #0x1
    sub r0, r1, r8
    str r0, [r2, #0x0]
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, lr}
    bx lr
    arm_func_end func_01ff82b4

    .global func_01ff849c
    arm_func_start func_01ff849c
func_01ff849c: ; 0x01ff849c
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, lr}
    ldr r0, .L_01ff85b4
    ldr r1, .L_01ff85b8
    ldr r2, [r0, #0x0]
    ldr r0, .L_01ff85bc
    ldr r1, [r1, r2, lsl #0x2]
    add r8, r0, r2, lsl #0x9
    cmp r1, #0x0
    ldr ip, .L_01ff85c0
    mov r7, #0x0
    ble .L_01ff84e4
.L_01ff84c8:
    ldr r0, [r8, r7, lsl #0x2]
    ldr r0, [r0, #0xc]
    ands r0, r0, #0x40000
    bne .L_01ff84e4
    add r7, r7, #0x1
    cmp r7, r1
    blt .L_01ff84c8
.L_01ff84e4:
    mov r4, ip, lsr #0x18
    mov r6, r4
    cmp r4, r7
    bge .L_01ff85a4
.L_01ff84f4:
    ldr lr, [r8, r6, lsl #0x2]
    ldr r0, [lr, #0x90]
    ldr r1, [lr, #0xc]
    mov r0, r0, lsl #0x14
    mov r0, r0, lsr #0x1e
    mov r3, r0, lsl #0x18
    ands r0, r1, #0x80000
    addne r3, r3, #0x20000
    bne .L_01ff8520
    ands r0, r1, #0x100000
    addeq r3, r3, #0x10000
.L_01ff8520:
    ldr r0, [lr, #0x24]
    mov r5, r6
    mov r0, r0, asr #0x10
    rsb r0, r0, #0x10000
    cmp r6, r4
    add r3, r3, r0
    blt .L_01ff8594
.L_01ff853c:
    sub r1, r5, r4
    ldr r0, [r8, r1, lsl #0x2]
    ldr r2, [r0, #0x90]
    ldr r10, [r0, #0xc]
    mov r2, r2, lsl #0x14
    mov r2, r2, lsr #0x1e
    mov r2, r2, lsl #0x18
    ands r9, r10, #0x80000
    addne r2, r2, #0x20000
    bne .L_01ff856c
    ands r9, r10, #0x100000
    addeq r2, r2, #0x10000
.L_01ff856c:
    ldr r9, [r0, #0x24]
    mov r9, r9, asr #0x10
    rsb r9, r9, #0x10000
    add r2, r2, r9
    cmp r3, r2
    bhs .L_01ff8594
    str r0, [r8, r5, lsl #0x2]
    mov r5, r1
    cmp r1, r4
    bge .L_01ff853c
.L_01ff8594:
    add r6, r6, #0x1
    str lr, [r8, r5, lsl #0x2]
    cmp r6, r7
    blt .L_01ff84f4
.L_01ff85a4:
    movs ip, ip, lsl #0x8
    bne .L_01ff84e4
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, lr}
    bx lr
.L_01ff85b4: .word data_027c0004
.L_01ff85b8: .word data_02121ad8
.L_01ff85bc: .word data_02121f00
.L_01ff85c0: .word 0x15070301
    arm_func_end func_01ff849c

    .global func_01ff85c4
    arm_func_start func_01ff85c4
func_01ff85c4: ; 0x01ff85c4
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    sub sp, sp, #0xc
    ldr r3, .L_01ff86f0
    mov lr, #0x0
    ldr r4, [r3, #0x0]
    mov ip, lr
    cmp r4, #0x0
    addeq sp, sp, #0xc
    moveq r0, #0x1
    ldmeqia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bxeq lr
    ldr r3, .L_01ff86f4
    mov r7, lr
    ldr r3, [r3, #0x0]
    mov r6, lr
    ldr r0, [r3, r0, lsl #0x2]
    ldrb r5, [r4, r0]
    add r0, r4, r0
    add r8, r0, #0x1
    mov r9, lr
    str lr, [sp, #0x4]
    str lr, [sp, #0x0]
    mov r11, #0x1
    mov r0, #0x100
.L_01ff8624:
    ldr r3, .L_01ff86f8
    mov r4, r0
    ldr r3, [r3, #0x0]
.L_01ff8630:
    mov r10, r5, asr r6
    ands r10, r10, #0x1
    addne r4, r3, r4, lsl #0x2
    subne r4, r4, #0x300
    ldrneh r4, [r4, #-0xfe]
    add r6, r6, #0x1
    addeq r4, r3, r4, lsl #0x2
    subeq r4, r4, #0x400
    ldreqh r4, [r4, #0x0]
    cmp r6, #0x8
    moveq r6, r9
    ldreqb r5, [r8], #0x1
    cmp r4, #0x100
    bhs .L_01ff8630
    and r3, r4, #0xff
    strb r3, [r1, r7]
    cmp r3, #0xf0
    add r7, r7, #0x1
    blo .L_01ff8690
    cmp ip, #0x0
    moveq r3, r3, lsl #0x18
    moveq ip, r11
    moveq lr, r3, lsr #0x10
    beq .L_01ff86b4
.L_01ff8690:
    cmp ip, #0x0
    andne r3, r4, #0xff
    orrne lr, lr, r3
    ldrne ip, [sp, #0x0]
    bne .L_01ff86b4
    cmp ip, #0x0
    ldreq r3, [sp, #0x4]
    andeq r4, r4, #0xff
    orreq lr, r3, r4
.L_01ff86b4:
    add r3, r1, r7
    ldrb r3, [r3, #-0x1]
    cmp r3, #0x0
    beq .L_01ff86d8
    cmp r7, r2
    addeq sp, sp, #0xc
    moveq r0, #0x2
    ldmeqia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bxeq lr
.L_01ff86d8:
    cmp lr, #0x0
    bne .L_01ff8624
    mov r0, #0x0
    add sp, sp, #0xc
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bx lr
.L_01ff86f0: .word data_027c001c
.L_01ff86f4: .word data_027c0014
.L_01ff86f8: .word data_027c0018
    arm_func_end func_01ff85c4

    .global func_01ff86fc
    arm_func_start func_01ff86fc
func_01ff86fc: ; 0x01ff86fc
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    sub sp, sp, #0x1c
    ldr r5, .L_01ff89c8
    ldr r6, .L_01ff89cc
    ldr r1, [r5, #0x0]
    ldr r0, [r6, #0x0]
    mov r10, #0x0
    str r0, [sp, #0x4]
    eor r0, r1, #0x1
    ldr r9, .L_01ff89d0
    ldr r4, .L_01ff89d4
    ldr r11, .L_01ff89d8
    str r0, [r5, #0x0]
    str r10, [sp, #0xc]
    str r10, [sp, #0x8]
    str r10, [sp, #0x10]
    str r10, [sp, #0x18]
    str r10, [sp, #0x14]
    mov r8, #0x20
    mov r7, #0x400
.L_01ff874c:
    ldr r0, .L_01ff89dc
    str r10, [r6, #0x0]
    ldr r0, [r0, #0x0]
    add r0, r0, r10
    ldrb r0, [r0, #0x38]
    cmp r0, #0x0
    beq .L_01ff8830
    mla r1, r10, r4, r9
    ldr r0, [r1, #0x4]
    add r3, r1, #0x8
    cmp r0, r3
    bne .L_01ff87a4
    str r8, [sp, #0x0]
    add r3, r1, r11
    ldr r1, [r5, #0x0]
    mov r2, r10, lsl #0xa
    add r1, r3, r1, lsl #0xa
    ldr r0, [sp, #0x8]
    add r2, r2, #0x7000000
    mov r3, r7
    bl func_0204e2e4
    b .L_01ff87c4
.L_01ff87a4:
    str r8, [sp, #0x0]
    ldr r1, [r5, #0x0]
    mov r2, r10, lsl #0xa
    add r1, r3, r1, lsl #0xa
    ldr r0, [sp, #0xc]
    add r2, r2, #0x7000000
    mov r3, r7
    bl func_0204e2e4
.L_01ff87c4:
    ldr r1, [r6, #0x0]
    mla r0, r1, r4, r9
    add r1, r0, #0x1000
    ldr r0, [sp, #0x10]
    strb r0, [r1, #0x329]
    bl func_0201fbe0
    ldr r0, [r6, #0x0]
    mul r2, r0, r4
    add r3, r9, r2
    ldr r1, [r9, r2]
    add r0, r3, #0x8
    str r1, [r3, #0x4]
    ldr r1, [r9, r2]
    cmp r1, r0
    bne .L_01ff8818
    ldr r0, [r6, #0x0]
    mul r1, r0, r4
    add r0, r9, r1
    add r0, r0, r11
    str r0, [r9, r1]
    b .L_01ff888c
.L_01ff8818:
    ldr r0, [r6, #0x0]
    mul r1, r0, r4
    add r0, r9, r1
    add r0, r0, #0x8
    str r0, [r9, r1]
    b .L_01ff888c
.L_01ff8830:
    mla r1, r10, r4, r9
    ldr r0, [r1, #0x4]
    add r3, r1, #0x8
    cmp r0, r3
    bne .L_01ff8868
    str r8, [sp, #0x0]
    ldr r1, [r5, #0x0]
    mov r2, r10, lsl #0xa
    add r1, r3, r1, lsl #0xa
    ldr r0, [sp, #0x14]
    add r2, r2, #0x7000000
    mov r3, r7
    bl func_0204e2e4
    b .L_01ff888c
.L_01ff8868:
    str r8, [sp, #0x0]
    add r3, r1, r11
    ldr r1, [r5, #0x0]
    mov r2, r10, lsl #0xa
    add r1, r3, r1, lsl #0xa
    ldr r0, [sp, #0x18]
    add r2, r2, #0x7000000
    mov r3, r7
    bl func_0204e2e4
.L_01ff888c:
    add r10, r10, #0x1
    cmp r10, #0x2
    blt .L_01ff874c
    ldr r0, .L_01ff89dc
    ldr r0, [r0, #0x0]
    ldr r0, [r0, #0x0]
    cmp r0, #0x0
    beq .L_01ff88b0
    blx r0
.L_01ff88b0:
    mov r4, #0x0
    ldr r6, .L_01ff89cc
    ldr r5, .L_01ff89dc
    mov r7, r4
.L_01ff88c0:
    str r4, [r6, #0x0]
    bl func_020169e0
    bl func_020aed8c
    bl func_0201fc64
    ldr r1, [r5, #0x0]
    ldr r0, [r6, #0x0]
    add r4, r4, #0x1
    add r1, r1, r0
    ldrb r0, [r1, #0x38]
    cmp r0, #0x0
    strneb r7, [r1, #0x38]
    cmp r4, #0x2
    blt .L_01ff88c0
    ldr r0, .L_01ff89dc
    ldr r1, [r0, #0x0]
    add r2, r1, #0x1c
    ldr r1, [r2, #0x0]
    add r1, r1, #0x1
    str r1, [r2, #0x0]
    ldr r1, [r0, #0x0]
    add r2, r1, #0x2c
    ldr r1, [r2, #0x0]
    add r1, r1, #0x1
    str r1, [r2, #0x0]
    ldr r3, [r0, #0x0]
    ldr r1, [r3, #0x2c]
    cmp r1, #0x3c
    blo .L_01ff8950
    ldr r1, [r3, #0x30]
    mov r2, #0x0
    str r1, [r3, #0x34]
    ldr r1, [r0, #0x0]
    str r2, [r1, #0x30]
    ldr r1, [r0, #0x0]
    ldr r0, [r1, #0x30]
    str r0, [r1, #0x2c]
.L_01ff8950:
    bl func_020b4f54
    ldr r3, .L_01ff89e0
    ldr r1, .L_01ff89e4
    ldr r2, .L_01ff89cc
    ldr r0, [sp, #0x4]
    add r1, r3, r1
    str r0, [r2, #0x0]
    ldr r0, [r1, #0x0]
    ldr r2, .L_01ff89e8
    orr r0, r0, #0x1
    str r0, [r1, #0x0]
    ldrh r0, [r2, #0x0]
    mov r1, #0x1
    ldr r0, .L_01ff89ec
    strh r1, [r2, #0x0]
    ldrb r1, [r0, #0x25c]
    ands r1, r1, #0x80
    ldrneb r1, [r0, #0x25c]
    addne sp, sp, #0x1c
    orrne r1, r1, #0x40
    strneb r1, [r0, #0x25c]
    ldmneia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bxne lr
    ldrb r1, [r0, #0x25c]
    bic r1, r1, #0x40
    strb r1, [r0, #0x25c]
    bl func_02097ec0
    add sp, sp, #0x1c
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bx lr
.L_01ff89c8: .word data_027c0024
.L_01ff89cc: .word data_027c0004
.L_01ff89d0: .word data_021422ac
.L_01ff89d4: .word 0x132c
.L_01ff89d8: .word 0x808
.L_01ff89dc: .word data_027c0020
.L_01ff89e0: .word data_027c0000
.L_01ff89e4: .word 0x3ff8
.L_01ff89e8: .word 0x4000208
.L_01ff89ec: .word data_021486a0
    arm_func_end func_01ff86fc

    .global run_slots
    arm_func_start run_slots
run_slots: ; 0x01ff89f0
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    sub sp, sp, #0x14
    mov r0, #0x0
    str r0, [sp, #0x0]
    ldr r9, .L_01ff8c3c
    mov r10, r0
    str r0, [sp, #0x8]
    mov r0, #0x4000
    ldr r5, .L_01ff8c40
    ldr r11, .L_01ff8c44
    ldr r4, .L_01ff8c48
    mov r6, #0x2
    str r0, [sp, #0x4]
    mov r8, #0x20
    mov r7, #0x1
.L_01ff8a2c:
    str r10, [r5, #0x0]
    cmp r10, #0x0
    bne .L_01ff8a3c
    bl read_input
.L_01ff8a3c:
    bl slot_pending
    cmp r0, #0x0
    beq .L_01ff8ab4
    bl func_0204dabc
    cmp r0, #0x0
    beq .L_01ff8a58
    bl func_02080634
.L_01ff8a58:
    bl func_020806d0
    cmp r0, #0x0
    bne .L_01ff8b40
    ldr r0, [r5, #0x0]
    ldr r1, [r4, #0x0]
    mvn r0, r8, lsl r0
    and r0, r1, r0
    str r0, [r4, #0x0]
    bl record_changed
    cmp r0, #0x0
    beq .L_01ff8b40
    ldrb r0, [r9, #0x0]
    cmp r0, #0x2
    bne .L_01ff8b40
    ldr r1, [r4, #0x0]
    ldr r0, [r5, #0x0]
    orr r0, r1, r8, lsl r0
    str r0, [r4, #0x0]
    strb r7, [r9, #0x0]
    bl func_02070fa4
    bl func_0204dc48
    str r7, [sp, #0x0]
    b .L_01ff8b40
.L_01ff8ab4:
    bl record_changed
    cmp r0, #0x0
    beq .L_01ff8b0c
    cmp r10, #0x1
    bne .L_01ff8af0
    ldrb r0, [r11, #0x0]
    cmp r0, #0x3
    bne .L_01ff8af0
    ldr r1, [r5, #0x0]
    mov r0, #0x8c
    mul r2, r1, r0
    ldr r0, .L_01ff8c4c
    ldr r0, [r0, r2]
    cmp r0, #0x12
    strneb r6, [r11, #0x0]
.L_01ff8af0:
    bl func_020807d8
    ldr r1, [r4, #0x0]
    ldr r0, [r5, #0x0]
    orr r0, r1, r8, lsl r0
    str r0, [r4, #0x0]
    strb r6, [r9, #0x0]
    b .L_01ff8b40
.L_01ff8b0c:
    ldr r1, [r5, #0x0]
    ldr r0, [sp, #0x4]
    ldr r2, [r4, #0x0]
    mov r0, r0, lsl r1
    ands r0, r2, r0
    bne .L_01ff8b40
    cmp r10, #0x1
    bne .L_01ff8b3c
    ldrb r0, [r11, #0x0]
    cmp r0, #0x0
    ldrne r0, [sp, #0x8]
    strneb r0, [r11, #0x0]
.L_01ff8b3c:
    bl call_entry
.L_01ff8b40:
    add r10, r10, #0x1
    cmp r10, #0x2
    add r9, r9, #0x1
    blt .L_01ff8a2c
    ldr r0, [sp, #0x0]
    bl age_files
    mov r0, #0x20
    ldr r9, .L_01ff8c3c
    ldr r4, .L_01ff8c48
    mov r8, #0x0
    mov r7, #0x3
    str r0, [sp, #0xc]
.L_01ff8b70:
    ldr r0, .L_01ff8c40
    str r8, [r0, #0x0]
    ldrb r0, [r9, #0x0]
    cmp r0, #0x1
    bne .L_01ff8c08
    ldr r0, .L_01ff8c40
    strb r7, [r9, #0x0]
    ldr r6, [r0, #0x0]
    ldr r0, .L_01ff8c4c
    mov r1, #0x8c
    mla r5, r6, r1, r0
    ldr r0, [r5, #0x2c]
    mov ip, r5
    bic r0, r0, #0x80
    str r0, [r5, #0x2c]
    add r11, r5, #0x58
    ldmia ip!, {r0, r1, r2, r3}
    stmia r11!, {r0, r1, r2, r3}
    ldmia ip!, {r0, r1, r2, r3}
    stmia r11!, {r0, r1, r2, r3}
    ldmia ip, {r0, r1, r2}
    stmia r11, {r0, r1, r2}
    add r10, r5, #0x2c
    ldmia r10!, {r0, r1, r2, r3}
    stmia r5!, {r0, r1, r2, r3}
    ldmia r10!, {r0, r1, r2, r3}
    stmia r5!, {r0, r1, r2, r3}
    ldmia r10, {r0, r1, r2}
    stmia r5, {r0, r1, r2}
    ldr r1, [r4, #0x0]
    ldr r0, [sp, #0xc]
    orr r0, r1, r0, lsl r6
    str r0, [r4, #0x0]
    bl call_mode
    ldr r0, [r4, #0x0]
    bic r0, r0, #0x800
    str r0, [r4, #0x0]
    bl flag_slot
.L_01ff8c08:
    bl update_slot
    bl step_affine
    bl step_motions
    bl func_0201fe44
    bl func_02066bb8
    add r8, r8, #0x1
    cmp r8, #0x2
    add r9, r9, #0x1
    blt .L_01ff8b70
    bl func_0209823c
    add sp, sp, #0x14
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bx lr
.L_01ff8c3c: .word data_027c006c
.L_01ff8c40: .word data_027c0004
.L_01ff8c44: .word data_027c0064
.L_01ff8c48: .word data_027c0008
.L_01ff8c4c: .word data_027c0070
    arm_func_end run_slots

    .global func_01ff8c50
    arm_func_start func_01ff8c50
func_01ff8c50: ; 0x01ff8c50
    stmdb sp!, {r1, r2, r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
    sub sp, sp, #0x24
    ldr r11, [r0], #0x4
    mov r5, #0xff
    and r3, r5, r11
    and r4, r5, r11, lsr #0x8
    mov r2, r11, lsr #0x10
    mov r5, r2, lsr #0x8
    rsb r5, r5, #0x8
    add r2, r5, r2, lsl #0x8
    add r5, sp, #0x4
.L_01ff8c7c:
    ldr r11, [r0], #0x4
    str r11, [r5], #0x4
    subs r3, r3, #0x4
    bne .L_01ff8c7c
    mov r8, #0x80000000
    mov ip, #0x0
    b .L_01ff8d90
.L_01ff8c98:
    mov r5, #0x1
    mov r9, r5
    adds r8, r8, r8
    ldreq r8, [r0], #0x4
    adceqs r8, r8, r8
    blo .L_01ff8d58
    add r9, r9, #0x1
.L_01ff8cb4:
    adds r8, r8, r8
    ldreq r8, [r0], #0x4
    adceqs r8, r8, r8
    blo .L_01ff8d58
    add r9, r9, #0x1
    adds r8, r8, r8
    ldreq r8, [r0], #0x4
    adceqs r8, r8, r8
    blo .L_01ff8d58
    add r9, r9, #0x1
    adds r8, r8, r8
    ldreq r8, [r0], #0x4
    adceqs r8, r8, r8
    blo .L_01ff8d58
    add r9, r9, #0x1
    cmp r9, #0x8
    bne .L_01ff8cb4
    subs r9, r9, #0x1
    bne .L_01ff8d10
    bx lr
    ldr r8, [r0], #0x4
    adceqs r8, r8, r8
    bx lr
.L_01ff8d10:
    movs r3, r8, lsl r9
    beq .L_01ff8d48
    rsb r3, r9, #0x20
    mov r3, r8, lsr r3
    orr r5, r3, r5, lsl r9
    mov r8, r8, lsl r9
    bx lr
.L_01ff8d2c:
    movs r5, r8, lsl r9
    beq .L_01ff8d48
    rsb r5, r9, #0x20
    mov r5, r8, lsr r5
    mov r8, r8, lsl r9
    bx lr
    mov r9, #0x8
.L_01ff8d48:
    adds r8, r8, r8
    ldreq r8, [r0], #0x4
    adceqs r8, r8, r8
    adc r5, r5, r5
.L_01ff8d58:
    subs r9, r9, #0x1
    bne .L_01ff8d48
    bx lr
    arm_func_end func_01ff8c50

    .global func_01ff8d64
    arm_func_start func_01ff8d64
func_01ff8d64: ; 0x01ff8d64
    movs r9, r2, lsr #0x10
    blne .L_01ff8d2c
    mov r11, r4
    mov r4, r5
    mov r5, r11
.L_01ff8d78:
    ands r9, r2, #0xff
    blne .L_01ff8d10
    eors ip, ip, #0x1
    movne r10, r5
    addeq r10, r10, r5, lsl #0x8
    streqh r10, [r1], #0x2
.L_01ff8d90:
    mov r5, #0x0
    mov r11, #0x0
    movs r9, r2, lsr #0x10
    blne .L_01ff8d2c
    cmp r5, r4
    bne .L_01ff8d78
    bl .L_01ff8c98
    mov r6, r5
    movs r5, r5, lsr #0x1
    bne .L_01ff8e50
    adds r8, r8, r8
    bleq #-0xb8
    blo .L_01ff8e78
    adds r8, r8, r8
    bleq #-0xc4
    blo func_01ff8d64
    bl .L_01ff8c98
    mov r6, r5
    cmp r5, #0x80
    blo .L_01ff8df8
    adds r8, r8, r8
    bleq #-0xe0
    adc r6, r5, r5
    and r6, r6, #0xff
    bl .L_01ff8c98
    sub r11, r5, #0x1
.L_01ff8df8:
    bl .L_01ff8c98
    cmp r5, #0x20
    addlo r5, r5, #0x3
    ldrlob r5, [sp, r5]
    movhs r9, #0x3
    blhs .L_01ff8d10
    and r5, r5, #0xff
    add r6, r6, #0x1
    add r6, r6, r11, lsl #0x8
.L_01ff8e1c:
    tst ip, #0x1
    addne r10, r10, r5, lsl #0x8
    strneh r10, [r1], #0x2
    subne r6, r6, #0x1
    add r10, r5, r5, lsl #0x8
.L_01ff8e30:
    and r5, r6, #0x1
    movs r6, r6, lsr #0x1
.L_01ff8e38:
    strneh r10, [r1], #0x2
    subs r6, r6, #0x1
    bgt .L_01ff8e38
    movs ip, r5
    andne r10, r10, #0xff
    b .L_01ff8d90
.L_01ff8e50:
    bl .L_01ff8c98
    cmp r5, #0xff
    beq .L_01ff8f58
    sub r11, r5, #0x1
    mov r9, r2, lsr #0x8
    ands r9, r9, #0xff
    beq .L_01ff8e78
    mov r11, r11, lsl r9
    bl .L_01ff8d2c
    orr r11, r11, r5
.L_01ff8e78:
    movs r5, r8, lsl #0x8
    movne r5, r8, lsr #0x18
    movne r8, r8, lsl #0x8
    bleq #-0x140
    add r11, r5, r11, lsl #0x8
    sub r7, r1, r11
    sub r7, r7, #0x1
    add r7, r7, ip
    add r6, r6, #0x1
    sub r5, r1, r7
    cmp r5, #0x1
    bgt .L_01ff8ed8
    bne .L_01ff8ec8
    ldrb r5, [r7], #0x1
    tst ip, #0x1
    beq .L_01ff8e1c
    add r10, r10, r5, lsl #0x8
    strh r10, [r1], #0x2
    sub r6, r6, #0x1
    b .L_01ff8e30
.L_01ff8ec8:
    tst ip, #0x1
    ldreqb r5, [r7], #0x1
    andne r5, r10, #0xff
    b .L_01ff8e1c
.L_01ff8ed8:
    tst r7, #0x1
    beq .L_01ff8ef8
    ldrb r5, [r7], #0x1
    eors ip, ip, #0x1
    movne r10, r5
    addeq r10, r10, r5, lsl #0x8
    streqh r10, [r1], #0x2
    subs r6, r6, #0x1
.L_01ff8ef8:
    movs r11, r6, lsr #0x1
    beq .L_01ff8f40
    tst ip, #0x1
    bne .L_01ff8f1c
.L_01ff8f08:
    ldrh r5, [r7], #0x2
    strh r5, [r1], #0x2
    subs r11, r11, #0x1
    bne .L_01ff8f08
    b .L_01ff8f38
.L_01ff8f1c:
    ldrh r5, [r7], #0x2
    add r5, r10, r5, lsl #0x8
    strh r5, [r1], #0x2
    mov r10, r5, lsr #0x10
    subs r11, r11, #0x1
    bne .L_01ff8f1c
    mov ip, #0x1
.L_01ff8f38:
    tst r6, #0x1
    beq .L_01ff8d90
.L_01ff8f40:
    ldrb r5, [r7], #0x1
    eors ip, ip, #0x1
    movne r10, r5
    addeq r10, r10, r5, lsl #0x8
    streqh r10, [r1], #0x2
    b .L_01ff8d90
.L_01ff8f58:
    tst ip, #0x1
    strneb r10, [r1], #0x1
    add sp, sp, #0x24
    ldmia sp!, {r0, r2, r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
    cmp r2, #0x0
    bxeq lr
    subs r1, r1, r0
    str r1, [r2, #0x0]
    bx lr
    arm_func_end func_01ff8d64

    .byte 0x00, 0x00, 0x00, 0x00

    .global func_01ff8f80
    arm_func_start func_01ff8f80
func_01ff8f80: ; 0x01ff8f80
    stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    mov r10, r0
    ldr ip, .L_01ff90e4
    ldrb r11, [ip, #0x22]
    cmp r11, #0x0
    beq .L_01ff91f4
    ldr r0, [ip, #0x0]
    add r1, r0, r10, lsl #0x1
    ldr r3, .L_01ff90e8
    stmdb sp!, {r0, r1, r2, r3}
    mov lr, sp
    ldr ip, .L_01ff90ec
    add ip, ip, r11, lsl #0x4
    add ip, ip, r11, lsl #0x3
.L_01ff8fb8:
    ldmdb ip!, {r0, r1, r2, r4, r5, r6}
    cmp r0, #0x0
    beq .L_01ff9020
    tst r0, #0x80000000
    movne r4, r4, lsr #0x8
    bicne r4, r4, #0xff00
    mla r8, r2, r10, r1
    add r7, r0, r8, asr #0x10
    mov r8, r8, lsl #0x10
    mov r8, r8, lsr #0x10
    cmp r2, #0x0
    blt .L_01ff9050
    cmp r7, r5
    bge .L_01ff906c
.L_01ff8ff0:
    stmia ip, {r7, r8}
    cmp r4, #0x0
    beq .L_01ff9020
    ldr r3, .L_01ff90f0
    cmp r2, #0x0
    addlo r1, r2, r1, lsl #0x10
    movlo r2, r4
    addlo r3, r3, #0x8
    ldr r3, [r3, r0, lsr #0x1d]
    bic r0, r0, #0x80000000
    stmlodb sp!, {r0, r1, r2, r3}
    stmhsdb sp!, {r0, r1, r2, r3, r4}
.L_01ff9020:
    subs r11, r11, #0x1
    bne .L_01ff8fb8
    mov lr, sp
    mov r0, #0x0
    mov r1, #0x0
    mov r2, #0x0
    mov r3, #0x0
    mov r4, #0x0
    mov r5, #0x0
    mov r6, #0x0
    mov r7, #0x0
    ldmia lr!, {r8, r9, r10, pc}
.L_01ff9050:
    cmp r7, r5
    blt .L_01ff906c
    b .L_01ff8ff0
.L_01ff905c:
    sub r7, r7, r6
    cmp r7, r5
    ble .L_01ff905c
    b .L_01ff90ac
.L_01ff906c:
    add r0, r0, r1, asr #0x10
    mov r1, r1, lsl #0x10
    mov r1, r1, lsr #0x10
    sub r3, r0, r5
    add r1, r1, r3, lsl #0x10
    mov r0, r5
    cmp r6, #0x0
    beq .L_01ff90c0
    ldr r3, .L_01ff90f4
    cmp r2, #0x0
    addlt r3, r3, #0x8
    ldr r3, [r3, r0, lsr #0x1d]
    blt .L_01ff905c
.L_01ff90a0:
    sub r7, r7, r6
    cmp r7, r5
    bge .L_01ff90a0
.L_01ff90ac:
    stmia ip, {r7, r8}
    cmp r4, #0x0
    bicne r0, r0, #0x80000000
    stmnedb sp!, {r0, r1, r2, r3, r4, r6}
    b .L_01ff9020
.L_01ff90c0:
    str r6, [ip, #0x0]
    ldr r3, .L_01ff90f8
    cmp r2, #0x0
    addlt r3, r3, #0x8
    ldr r3, [r3, r0, lsr #0x1d]
    cmp r4, #0x0
    bicne r0, r0, #0x80000000
    stmnedb sp!, {r0, r1, r2, r3, r4}
    b .L_01ff9020
.L_01ff90e4: .word data_02148678
.L_01ff90e8: .word 0x1ff90fc
.L_01ff90ec: .word data_02148c00
.L_01ff90f0: .word 0x20b4274
.L_01ff90f4: .word 0x20b4294
.L_01ff90f8: .word 0x20b4284
    add r10, r8, #0x1000
    mov r0, r0, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r8], #0x2
    mov r0, r2, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r8], #0x2
    mov r0, r4, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r8], #0x2
    mov r0, r6, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r8], #0x2
    mov r0, r1, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r10], #0x2
    mov r0, r3, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r10], #0x2
    mov r0, r5, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r10], #0x2
    mov r0, r7, asr #0x8
    cmp r0, #0x7f00
    movgt r0, #0x7f00
    cmnlt r0, #0x8000
    mvnlt r0, #0x7f00
    strh r0, [r10], #0x2
    cmp r8, r9
    strlt r8, [lr, #-0x10]
    movlt r0, #0x0
    movlt r1, #0x0
    movlt r2, #0x0
    movlt r3, #0x0
    movlt r4, #0x0
    movlt r5, #0x0
    movlt r6, #0x0
    movlt r7, #0x0
    movlt lr, sp
    ldmltia lr!, {r8, r9, r10, pc}
    mov sp, lr
.L_01ff91f4:
    ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    bx lr
    arm_func_end func_01ff8f80

    .global func_01ff91fc
    arm_func_start func_01ff91fc
func_01ff91fc: ; 0x01ff91fc
    add r8, r8, r9, asr #0x10
    ldrsb r11, [r8, #0x0]
    ldrsb ip, [r8, #0x1]
    str lr, [sp, #-0x4]!
    ldr lr, [lr, #0x0]
    mov r9, r9, lsl #0x10
    mov r9, r9, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r9, ip
    add r9, r10, r9, lsl #0x1
    add ip, ip, r11, lsl #0xf
    smlawb r0, ip, lr, r0
    smlawt r1, ip, lr, r1
    add r8, r8, r9, asr #0x10
    ldrsb r11, [r8, #0x0]
    ldrsb ip, [r8, #0x1]
    mov r9, r9, lsl #0x10
    mov r9, r9, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r9, ip
    add r9, r10, r9, lsl #0x1
    add ip, ip, r11, lsl #0xf
    smlawb r2, ip, lr, r2
    smlawt r3, ip, lr, r3
    add r8, r8, r9, asr #0x10
    ldrsb r11, [r8, #0x0]
    ldrsb ip, [r8, #0x1]
    mov r9, r9, lsl #0x10
    mov r9, r9, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r9, ip
    add r9, r10, r9, lsl #0x1
    add ip, ip, r11, lsl #0xf
    smlawb r4, ip, lr, r4
    smlawt r5, ip, lr, r5
    add r8, r8, r9, asr #0x10
    ldrsb r11, [r8, #0x0]
    ldrsb ip, [r8, #0x1]
    mov r9, r9, lsl #0x10
    mov r9, r9, lsr #0x11
    add r10, r10, r9, lsl #0x1
    sub ip, ip, r11
    smulbb ip, r9, ip
    ldr r9, [sp], #0x4
    add ip, ip, r11, lsl #0xf
    smlawb r6, ip, lr, r6
    smlawt r7, ip, lr, r7
    add lr, r9, #0x4
    str r8, [lr, #-0x14]
    str r10, [lr, #-0x10]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff91fc

    .global func_01ff92c8
    arm_func_start func_01ff92c8
func_01ff92c8: ; 0x01ff92c8
    ldrsb r11, [r8, #0x0]
    ldrsb ip, [r8, #0x1]!
    str lr, [sp, #-0x4]!
    cmn r9, r9, lsl #0x10
    mov lr, r9, lsr #0x11
    sub ip, ip, r11
    smulbb lr, ip, lr
    add lr, lr, r11, lsl #0xf
    addhs r11, ip, r11
    ldrhssb ip, [r8, #0x1]!
    smlawb r0, lr, r10, r0
    smlawt r1, lr, r10, r1
    add r9, r9, r9, lsl #0x10
    cmn r9, r9, lsl #0x10
    mov lr, r9, lsr #0x11
    sub ip, ip, r11
    smulbb lr, ip, lr
    add lr, lr, r11, lsl #0xf
    addhs r11, ip, r11
    ldrhssb ip, [r8, #0x1]!
    smlawb r2, lr, r10, r2
    smlawt r3, lr, r10, r3
    add r9, r9, r9, lsl #0x10
    cmn r9, r9, lsl #0x10
    mov lr, r9, lsr #0x11
    sub ip, ip, r11
    smulbb lr, ip, lr
    add lr, lr, r11, lsl #0xf
    addhs r11, ip, r11
    ldrhssb ip, [r8, #0x1]!
    smlawb r4, lr, r10, r4
    smlawt r5, lr, r10, r5
    add r9, r9, r9, lsl #0x10
    sub ip, ip, r11
    mov lr, r9, lsr #0x11
    smulbb ip, r9, lr
    ldr lr, [sp], #0x4
    add ip, ip, r11, lsl #0xf
    adds r9, r9, r9, lsl #0x10
    smlawb r6, ip, r10, r6
    smlawt r7, ip, r10, r7
    sublo r8, r8, #0x1
    strd r8, [lr, #-0x10]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff92c8

    .global func_01ff9378
    arm_func_start func_01ff9378
func_01ff9378: ; 0x01ff9378
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    ldr r8, [lr], #0x8
    adds r9, r9, r10
    add ip, ip, r11, lsl #0xf
    ldrpl r10, [lr, #-0x4]
    smlawb r0, ip, r8, r0
    smlawt r1, ip, r8, r1
    ldr r8, [lr, #-0x18]
.L_01ff93b0:
    subpls r9, r9, r10, lsl #0x10
    bpl .L_01ff93b0
    ldr r10, [lr, #-0x10]
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    ldr r8, [lr, #-0x8]
    adds r9, r9, r10
    add ip, ip, r11, lsl #0xf
    ldrpl r10, [lr, #-0x4]
    smlawb r2, ip, r8, r2
    smlawt r3, ip, r8, r3
    ldr r8, [lr, #-0x18]
.L_01ff93f4:
    subpls r9, r9, r10, lsl #0x10
    bpl .L_01ff93f4
    ldr r10, [lr, #-0x10]
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    ldr r8, [lr, #-0x8]
    adds r9, r9, r10
    add ip, ip, r11, lsl #0xf
    ldrpl r10, [lr, #-0x4]
    smlawb r4, ip, r8, r4
    smlawt r5, ip, r8, r5
    ldr r8, [lr, #-0x18]
.L_01ff9438:
    subpls r9, r9, r10, lsl #0x10
    bpl .L_01ff9438
    ldr r10, [lr, #-0x10]
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    ldr r8, [lr, #-0x8]
    adds r9, r9, r10
    add ip, ip, r11, lsl #0xf
    ldrpl r10, [lr, #-0x4]
    smlawb r6, ip, r8, r6
    smlawt r7, ip, r8, r7
.L_01ff9478:
    subpls r9, r9, r10, lsl #0x10
    bpl .L_01ff9478
    str r9, [lr, #-0x14]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff9378

.word #0x0
    .global func_01ff948c
    arm_func_start func_01ff948c
func_01ff948c: ; 0x01ff948c
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    str lr, [sp, #-0x4]!
    str r8, .L_01ff9488
    ldr lr, [lr, #0x0]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    adds r9, r9, r10
    ldr r8, .L_01ff9488
    add ip, ip, r11, lsl #0xf
    bpl .L_01ff9560
    smlawb r0, ip, lr, r0
    smlawt r1, ip, lr, r1
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    adds r9, r9, r10
    ldr r8, .L_01ff9488
    add ip, ip, r11, lsl #0xf
    bpl .L_01ff9560
    smlawb r2, ip, lr, r2
    smlawt r3, ip, lr, r3
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    adds r9, r9, r10
    ldr r8, .L_01ff9488
    add ip, ip, r11, lsl #0xf
    bpl .L_01ff9560
    smlawb r4, ip, lr, r4
    smlawt r5, ip, lr, r5
    add ip, r8, r9, asr #0x10
    ldrsb r11, [ip, #0x0]
    ldrsb ip, [ip, #0x1]
    mov r8, r9, lsl #0x10
    mov r8, r8, lsr #0x11
    sub ip, ip, r11
    smulbb ip, r8, ip
    adds r9, r9, r10
    add ip, ip, r11, lsl #0xf
    smlawmib r6, ip, lr, r6
    smlawmit r7, ip, lr, r7
.L_01ff9560:
    ldr lr, [sp], #0x4
    str r9, [lr, #-0xc]
    addpl r10, pc, #0x0
    strpl r10, [lr, #-0x4]
    add lr, lr, #0x4
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff948c

    .global func_01ff9578
    arm_func_start func_01ff9578
func_01ff9578: ; 0x01ff9578
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    str lr, [sp, #-0x4]!
    ldr lr, [lr, #0x0]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r0, r11, lr, r0
    smlawt r1, r11, lr, r1
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r2, r11, lr, r2
    smlawt r3, r11, lr, r3
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r4, r11, lr, r4
    smlawt r5, r11, lr, r5
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    ldr r8, [sp], #0x4
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r6, r11, lr, r6
    smlawt r7, r11, lr, r7
    add lr, r8, #0x4
    str r9, [lr, #-0x10]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff9578

    .global func_01ff9620
    arm_func_start func_01ff9620
func_01ff9620: ; 0x01ff9620
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov r8, r9, lsl #0x10
    mov r8, r8, asr #0x11
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    ldr r8, [lr], #0x8
    adds r9, r9, r10
    smlawb r0, r11, lr, r0
    smlawt r1, r11, lr, r1
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r2, r11, lr, r2
    smlawt r3, r11, lr, r3
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r4, r11, lr, r4
    smlawt r5, r11, lr, r5
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    ldr r8, [sp], #0x4
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    add r9, r9, r10
    smlawb r6, r11, lr, r6
    smlawt r7, r11, lr, r7
    add lr, r8, #0x4
    str r9, [lr, #-0x10]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff9620

    .global func_01ff96c8
    arm_func_start func_01ff96c8
func_01ff96c8: ; 0x01ff96c8
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    str lr, [sp, #-0x4]!
    ldr lr, [lr, #0x0]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    adds r9, r9, r10
    bpl .L_01ff976c
    smlawb r0, r11, lr, r0
    smlawt r1, r11, lr, r1
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    adds r9, r9, r10
    bpl .L_01ff976c
    smlawb r2, r11, lr, r2
    smlawt r3, r11, lr, r3
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    adds r9, r9, r10
    bpl .L_01ff976c
    smlawb r4, r11, lr, r4
    smlawt r5, r11, lr, r5
    add ip, r8, r9, asr #0x11
    ldrsh r11, [ip, ip]!
    ldrsh ip, [ip, #0x2]
    mov ip, ip, lsl #0x10
    sub r11, r11, ip, asr #0x10
    smlabb r11, r9, r11, ip
    adds r9, r9, r10
    smlawmib r6, r11, lr, r6
    smlawmit r7, r11, lr, r7
.L_01ff976c:
    ldr lr, [sp], #0x4
    addpl r10, pc, #0x0
    strpl r10, [lr, #-0x4]
    add lr, lr, #0x4
    str r9, [lr, #-0x10]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff96c8

    .global func_01ff9784
    arm_func_start func_01ff9784
func_01ff9784: ; 0x01ff9784
    add r11, r8, r9, asr #0x10
    ldrsb r11, [r11, #0x0]
    str lr, [sp, #-0x4]!
    ldr lr, [lr, #0x0]
    add r9, r9, r10
    add ip, r8, r9, asr #0x10
    smlabb r0, r11, lr, r0
    smlabt r1, r11, lr, r1
    ldrsb ip, [ip, #0x0]
    add r9, r9, r10
    add r11, r8, r9, asr #0x10
    smlabb r2, ip, lr, r2
    smlabt r3, ip, lr, r3
    ldrsb r11, [r11, #0x0]
    add r9, r9, r10
    add r11, r8, r9, asr #0x10
    smlabb r4, r11, lr, r4
    smlabt r5, r11, lr, r5
    ldrsb ip, [ip, #0x0]
    add r9, r9, r10
    ldr r8, [sp], #0x4
    smlabb r6, ip, lr, r6
    smlabt r7, ip, lr, r7
    add lr, r8, #0x4
    str r9, [lr, #-0x10]
    ldmia lr!, {r8, r9, r10, pc}
    arm_func_end func_01ff9784

    .global func_01ff97ec
    arm_func_start func_01ff97ec
func_01ff97ec: ; 0x01ff97ec
    stmdb sp!, {lr}
    mov ip, #0x4000000
    add ip, ip, #0x210
    ldr r1, [ip, #-0x8]
    cmp r1, #0x0
    ldmeqia sp!, {pc}
    ldmia ip, {r1, r2}
    ands r1, r1, r2
    ldmeqia sp!, {pc}
    mov r3, #0x80000000
.L_01ff9814:
    clz r0, r1
    bics r1, r1, r3, lsr r0
    bne .L_01ff9814
    mov r1, r3, lsr r0
    str r1, [ip, #0x4]
    rsbs r0, r0, #0x1f
    ldr r1, .L_01ff983c
    ldr r0, [r1, r0, lsl #0x2]
    ldr lr, .L_01ff9840
    bx r0
.L_01ff983c: .word data_02121974
.L_01ff9840: .word func_01ff9844
    arm_func_end func_01ff97ec

    .global func_01ff9844
    arm_func_start func_01ff9844
func_01ff9844: ; 0x01ff9844
    ldr ip, .L_01ff9988
    ldrh r3, [ip, #0x0]
    mov r0, #0x0
    cmp r3, #0x0
    beq .L_01ff988c
    strh r0, [ip, #0x0]
    ldr ip, .L_01ff998c
    mov r1, #0x1
    strh r1, [ip, #0x0]
    ldr ip, [ip, #0xc]
    mov r2, #0x1
.L_01ff9870:
    cmp ip, #0x0
    beq .L_01ff988c
    ldr r0, [ip, #0x6c]
    tst r3, r1, lsl r0
    strne r2, [ip, #0x64]
    ldr ip, [ip, #0x68]
    b .L_01ff9870
.L_01ff988c:
    ldr ip, .L_01ff998c
    ldrh r1, [ip, #0x0]
    cmp r1, #0x0
    ldreq pc, [sp], #0x4
    mov r1, #0x0
    strh r1, [ip, #0x0]
    mov r3, #0xd2
    msr cpsr_c, r3
    add r2, ip, #0xc
    ldr r1, [r2, #0x0]
.L_01ff98b4:
    cmp r1, #0x0
    ldrneh r0, [r1, #0x64]
    cmpne r0, #0x1
    ldrne r1, [r1, #0x68]
    bne .L_01ff98b4
    cmp r1, #0x0
    bne .L_01ff98dc
.L_01ff98d0:
    mov r3, #0x92
    msr cpsr_c, r3
    ldr pc, [sp], #0x4
.L_01ff98dc:
    ldr r0, [ip, #0x8]
    cmp r1, r0
    beq .L_01ff98d0
    ldr r3, [ip, #0x10]
    cmp r3, #0x0
    beq .L_01ff9904
    stmdb sp!, {r0, r1, ip}
    mov lr, pc
    bx r3
    ldmia sp!, {r0, r1, ip}
.L_01ff9904:
    str r1, [ip, #0x8]
    mrs r2, spsr
    str r2, [r0, #0x0]!
    stmdb sp!, {r0, r1}
    add r0, r0, #0x0
    add r0, r0, #0x48
    ldr r1, .L_01ff9990
    blx r1
    ldmia sp!, {r0, r1}
    ldmib sp!, {r2, r3}
    stmib r0!, {r2, r3}
    ldmib sp!, {r2, r3, ip, lr}
    stmib r0!, {r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, ip, sp, lr}^
    stmib r0!, {lr}
    mov r3, #0xd3
    msr cpsr_c, r3
    stmib r0!, {sp}
    stmdb sp!, {r1}
    add r0, r1, #0x0
    add r0, r0, #0x48
    ldr r1, .L_01ff9994
    blx r1
    ldmia sp!, {r1}
    ldr sp, [r1, #0x44]
    mov r3, #0xd2
    msr cpsr_c, r3
    ldr r2, [r1, #0x0]!
    msr spsr_fc, r2
    ldr lr, [r1, #0x40]
    ldmib r1!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, ip, sp, lr}^
    mov r0, r0
    stmda sp!, {r0, r1, r2, r3, ip, lr}
    ldmia sp!, {pc}
.L_01ff9988: .word data_027c0188
.L_01ff998c: .word data_0214afbc
.L_01ff9990: .word save_divider
.L_01ff9994: .word restore_divider
    arm_func_end func_01ff9844

    .global start_dma
    arm_func_start start_dma
start_dma: ; 0x01ff9998
    stmdb sp!, {r4, r5, r6, r7, lr}
    sub sp, sp, #0x4
    mov r7, r0
    mov r6, r1
    mov r5, r2
    mov r4, r3
    bl disable_irq
    ldr r2, .L_01ff99e4
    mov r1, #0xc
    mla r1, r7, r1, r2
    str r6, [r1, #0x0]
    str r5, [r1, #0x4]
    str r4, [r1, #0x8]
    ldr r1, [r2, #0x0]
    ldr r1, [r2, #0x0]
    bl restore_irq
    add sp, sp, #0x4
    ldmia sp!, {r4, r5, r6, r7, lr}
    bx lr
.L_01ff99e4: .word 0x40000b0
    arm_func_end start_dma

