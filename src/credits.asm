; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

CREDITS_DELAY equ 300

SECTION "Credits",ROM0

DisplayCredits::
	di 
	nop
	call SwitchLCDOff
	
	ld a ,128+2
	ld [rBCPS],a
	xor a
	ld [rBCPD],a
	ld [rBCPD],a
	
	ld a ,128
	ld [rBCPS],a
	xor a
	ld [rBCPD],a
	ld [rBCPD],a
	ld [rBCPD],a
	ld [rBCPD],a
	ld [rBCPD],a
	ld [rBCPD],a
	ld [rBCPD],a
	ld [rBCPD],a
	
	xor a 
	ld [rLCDC],a

	SET_VIDEOBANK 0
	SET_ROMBANK ROMBANK_CREDITS
	
	ld hl,creditsTiles
	ld de,_VRAM
	ld bc,creditsPalette-creditsTiles
	COPY_16BIT	

	ld hl,creditsMap	
	ld de,_SCRN0
	ld bc,creditsAttr-creditsMap
	COPY_16BIT
	
	SET_VIDEOBANK 1
	
	ld hl,creditsAttr
	ld de,_SCRN0
	ld bc,creditsPalette-creditsAttr
	COPY_16BIT

	ld hl,creditsPalette
	ld de,rBCPS
	ld a,128
	ld [de],a
	inc de
	ld c,64
.se2:
	ld a,[hl+]
	ld [de],a
	dec c
	jr nz,.se2
	ld a, %10010001
	ld [rLCDC],a	
		
	ld bc,CREDITS_DELAY
.wait1: 	
	ld a,[rLY]
	cp 145
	jr nz,.wait1
.wait2: 	
	ld a,[rLY]
	cp 144
	jr nz,.wait2
	
	dec bc
	ld a,b
	or c
	jr nz,.wait1 	
	ret
