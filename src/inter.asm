; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "inter",ROM0

;A contains type:
;0 - new level
;1 - game over
;2 - game end

Inter::
	di
	nop
	push af
	call SwitchLCDOff
	SET_VIDEOBANK 0
	SET_ROMBANK ROMBANK_INTER

	ld hl,intert
	ld de,_VRAM
	ld bc,interp-intert
	COPY_16BIT
	
	ld hl,interp
	ld de,rBCPS
	ld a,128
	ld [de],a
	inc de
	ld c,64

.copyColors:
	ld a,[hl+]
	ld [de],a
	dec c
	jr nz,.copyColors
	
	pop af
	push af
	
	ld bc,0
	or a
	jr z,.spox
	ld bc,20*18
	cp 1
	jr z,.spox
	ld bc,20*18*2

.spox:		
	push bc
	ld hl,interm
	add hl,bc
	push hl
	pop de
	
	ld hl,_SCRN0
	call CopyData
	
	SET_VIDEOBANK 1
	
	pop bc
	
	ld hl,intera
	add hl,bc
	push hl
	pop de
	
	ld hl,_SCRN0
	call CopyData
	
	xor a
	ld [rSCX],a ; reset scroll
	ld [rSCY],a
	SET_VIDEOBANK 0
	
	pop af
	or a
	jr nz,.skip
	
	ld a,[level]
	inc a
	cp 10
	jr nz,.s11
	xor a
.s11:	
	add a,a
	add 52
	ld [_SCRN0+32*3+14],a
	inc a
	ld [_SCRN0+32*4+14],a

	ld a,[level]
	cp 9
	jr nz,.label1
	
	ld a,54
	ld [_SCRN0+32*3+13],a
	inc a
	ld [_SCRN0+32*4+13],a
	jr .skip

.label1:
	ld a,72
	ld [_SCRN0+32*3+13],a
	ld [_SCRN0+32*4+13],a
	
.skip:	
	push af
	
	ld a,%10010001
	ld [rLCDC],a
	ld bc,200
	
.wait0:
	ld a,[rLY]
	cp 144
	jr nz,.wait0

.wait1:
	ld a,[rLY]
	cp 140
	jr nz,.wait1
	
	dec bc 
	ld a,b
	or c
	jr nz,.wait0	
		
	pop af

	cp 2 ; end fo game - dead loop
	ret nz

.deadloop:
	jr .deadloop
	
;Copy screen 20x18 tiles

CopyData:
	ld b,18
.l2:
	ld c,20	
.l1:	
	ld a,[de]
	inc de
	ld [hl+],a
	dec c
	jr nz,.l1
	dec b
	ret z
	
	push de
	ld de,12
	add hl,de
	pop de
	jr .l2
	
	
	
	