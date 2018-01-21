; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"
	
TITLE_EXIT_DELAY equ 36
C_START_LINE equ 0
C_END_LINE equ	103
PS_Y equ 13*8+16
PS_X equ 5*8+8+8
PS_A equ 8
PS_KR equ 16

PS_Y2 equ 13*8+16+22
PS_X2 equ 5*8+8
PS_KR2 equ 16

SECTION "Title",ROM0

TitleScreen::
	di 
	nop	
	call SwitchLCDOff
	SET_VIDEOBANK 0
	SET_ROMBANK 1
	
	ld hl,titleTiles
	ld de,_VRAM
	ld bc,titleTilesEnd - titleTiles
	COPY_16BIT
	
	SET_VIDEOBANK 1
	
	ld hl,titleObjects
	ld de,_VRAM
	ld bc,titleObjectsEnd - titleObjects
	COPY_16BIT

	call ClearSprites
	
	xor a
	ld [rSCX],a
	ld [rSCY],a
	SET_VIDEOBANK 0
	
	ld hl,titlePalette
	ld de,rBCPS
	ld a,128
	ld [de],a
	inc de
	ld c,64

.inLoop:
	ld a,[hl+]
	ld [de],a
	dec c
	jr nz,.inLoop
	
	ld hl,titleMap	
	ld de,_SCRN0
	ld bc,titleMapEnd - titleMap 
	COPY_16BIT
	
	SET_VIDEOBANK 1
	
	ld hl,titleAttr
	ld de,_SCRN0
	ld bc,titleAttrEnd - titleAttr
	COPY_16BIT
	
	ld a,%10010111 
	ld [rLCDC],a	
	
	xor a
	ld [a_GLOBAL+1],a

	xor a
	ld [rIF],a
	ld a,2
	ld [rIE],a
	ld hl,rSTAT
	ld [hl],32
	
	call ResetStars
	call UpdateStars
	
	ld hl,ScanlineMenu
	call SetScanlineFunction

	xor a
	ld [exitTitle],a
	ei
	nop

titleLoop:
	call UpdateStars
waitVbl:	
	ld a,[rLY]
	cp a,145
	jr nz,waitVbl
	
	di
	nop
	ld a,[flash]
	inc a
	ld [flash],a
	bit 5,a
	jr nz,.hide

	ld hl,_RAM
	ld de, TextStart
	ld c,10*4*2

.copyData:
	ld a,[de]
	ld [hl+],a
	inc de
	dec c
	jr nz,.copyData	
	jr .flashDone

.hide:
	ld hl,_RAM
	ld c,10*4*2

.clearData:
	xor a
	ld [hl+],a
	inc de
	dec c
	jr nz,.clearData	
	
.flashDone:
	ld a,[exitTitle]
	or a
	jr z,.noExit
	dec a
	jr z,.doExit
	ld [exitTitle],a
	jr .noKeyPressed

.doExit:
	call ClearSprites
	call _HRAM
	jp .endCode

.noExit:		
	call ReadKeys
	ld a,[inputMask]
	or a
	jr z,.noKeyPressed
	ld a,TITLE_EXIT_DELAY
	ld [exitTitle],a

	PLAY_SFX 2

.noKeyPressed:		
	call _HRAM

	;top line color fix
	ld de,1023
	ld a,128
	ld [rBCPS],a
	ld a,e
	ld [rBCPD],a
	ld a,d
	ld [rBCPD],a
	ld a,128+2
	ld [rOCPS],a
	xor a
	ld [rOCPD],a
	ld [rOCPD],a
	ld hl,$ffff
	ld a,128+12
	ld [rOCPS],a
	
	ld a,l
	ld [rOCPD],a
	ld a,h
	ld [rOCPD],a

	call UpdateAudio
	
	ei 
	nop
	jr continueTitleLoop

.endCode:	
	di 
	nop
	
	call ClearSprites
	xor a
	ld  [rIF],a
	ld  [rIE],a
	ret

continueTitleLoop:
	ld a,[a_GLOBAL+2]
	inc a
	ld [a_GLOBAL+2],a
	and %111
	jr nz,.sos
	ld a,[a_GLOBAL+1]
	inc a
	and %111111
	ld [a_GLOBAL+1],a
.sos:
	jp titleLoop

ScanlineMenu:        
	push af
	push de
	push hl
	SET_ROMBANK ROMBANK_DATA
	call SinusWobble
	pop hl
	pop de
	pop af
	reti

SinusWobble:
	ld a,[rLY]
	cp C_START_LINE
	ret c
	cp C_END_LINE
	jr nc,.overRange
	
	push hl
	push de
	push af
	ld h,$60 ;colt table @ $6000
	cp 128
	jr c,.skipInc
	inc h
	
.skipInc:	
	add a,a
	ld l,a
	
	WAIT_VRAM
	
	ld a,128
	ld [rBCPS],a
	ld a,[hl+]
	ld [rBCPD],a
	ld a,[hl]
	ld [rBCPD],a
	ld hl,$4000
	ld a,[a_GLOBAL+1]
	ld d,a
	ld e,0
	srl d
	rr e
	add hl,de
	pop af
	sub C_START_LINE
	add l
	ld l,a
	ld a,0
	adc h
	ld h,a

.wait:
      	ld a,[rSTAT]
      	bit 1,a
      	jr nz,.wait
	
	ld a,[hl]
	ld [rSCY],a	
	pop de
	pop hl
	ret

.overRange:
	push	af
	ld h,$60 ;colt table @ $6000
	cp 128
	jr c,.skipInc2
	inc h
	
.skipInc2:	
	add a,a
	ld l,a
	
	WAIT_VRAM
	
	ld a,128
	ld [rBCPS],a
	ld a,[hl+]
	ld [rBCPD],a
	ld a,[hl]
	ld [rBCPD],a
	pop af
	
	ld hl,stab
	sub 103 ; ??
	add a,a
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	
	ld a,128+4
	ld [rOCPS],a
	ld a,[hl+]
	ld [rOCPD],a
	ld a,[hl]
	ld [rOCPD],a

	xor a
	ld [rSCY],a
	ret
	
ResetStars:
	ld de,stars
	ld hl,StarsTable
	ld c,9*4
	COPY_8BIT
	ret
	
UpdateStars:
	ld de,stars
	ld hl,$c000+20*4
	ld c,9

.loop:
	push bc	
	
	ld a,[de]
	inc de
	ld [hl+],a
	inc hl
	inc hl
	inc hl
	ld [hl+],a
	ld a,[de]
	inc de
	
	ld [hl-],a ;x2
	sub 8
	
	dec hl
	dec hl
	dec hl
	
	ld [hl+],a
	
	ld a,[de]
	inc de
	or a
	ld a,24
	jr z,.skipadd
	add a,a ;48 - second star

.skipadd:
	ld c,a
	ld a,[de]
	inc de
	
	push hl
	ld hl,StarsPhases
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	ld a,[hl]
	pop hl

	add a,a
	add a,a
	add c
	ld [hl+],a
	inc hl
	inc hl
	inc hl
	
	add 2
	ld [hl+],a
	ld a,9
	ld [hl+],a
	push hl
	ld bc,-5
	add hl,bc
	ld [hl],a
	pop hl
	
	pop bc
	dec c
	jp nz,.loop

	ld a,[flash]
	and 7
	ret nz
	
	ld hl,stars+3
	ld de,4
	ld c,9

.loop3:
	ld a,[hl]
	inc a
	and 15
	ld [hl],a
	add hl,de
	dec c
	jr nz,.loop3	
	ret	

ClearSprites:
	ld hl,$c000
	ld c,40*4
	xor a
.clear:
	ld [hl+],a
	dec c
	jr nz,.clear			
	ret

TextStart:
	;p
	db PS_Y
	db PS_X
	db 0
	db PS_A
	
	db PS_Y
	db PS_X+8
	db 2
	db PS_A
	
	;u
	db PS_Y
	db PS_X+PS_KR*1
	db 4
	db PS_A
	
	db PS_Y
	db PS_X+8+PS_KR*1
	db 6
	db PS_A
	
	;s
	db PS_Y
	db PS_X+PS_KR*2
	db 8
	db PS_A
	
	db PS_Y
	db PS_X+8+PS_KR*2
	db 10
	db PS_A
	
	;h
	db PS_Y
	db PS_X+PS_KR*3
	db 12
	db PS_A
	
	db PS_Y
	db PS_X+8+PS_KR*3
	db 14
	db PS_A
	
	db 144+32
	db 144+32
	db 12
	db PS_A
	
	db 144+32
	db 144+32
	db 14
	db PS_A

	;s
	db PS_Y2
	db PS_X2+PS_KR2*0
	db 8
	db PS_A
	
	db PS_Y2
	db PS_X2+8+PS_KR2*0
	db 10
	db PS_A
	
	;t
	db PS_Y2
	db PS_X2+PS_KR2*1
	db 16
	db PS_A
	
	db PS_Y2
	db PS_X2+8+PS_KR2*1
	db 18
	db PS_A
	
	;a
	db PS_Y2
	db PS_X2+PS_KR2*2
	db 20
	db PS_A
	
	db PS_Y2
	db PS_X2+8+PS_KR2*2
	db 22
	db PS_A
	
	;r
	db PS_Y2
	db PS_X2+PS_KR2*3
	db 76
	db PS_A
	
	db PS_Y2
	db PS_X2+8+PS_KR2*3
	db 78
	db PS_A
	
	;t
	db PS_Y2
	db PS_X2+PS_KR2*4
	db 16
	db PS_A
	
	db PS_Y2
	db PS_X2+8+PS_KR2*4
	db 18
	db PS_A
	
StarsPhases:
	db 0,1,2,3,4,5,5,5,5,5,4,3,2,1,0,0,0,0,0,0
	
StarsTable:
	db 16,16,0,0
	db 6*8,4*8,1,5
	db 8*8,16,0,4
	db 11*8,3*8,1,8
	db 16,18*8,1,3
	db 5*8,16*8,0,7
	db 4*8,20*8,0,1
	db 11*8,19*8,0,9
	db 7*8,19*8,1,6


