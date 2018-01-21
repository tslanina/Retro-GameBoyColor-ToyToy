; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "COPY_8BIT",ROM0[0]			;COPY C
copycloop:
	ld a,[hl+]
	ld [de],a
	inc de
	dec c
	jr nz,copycloop
	ret

SECTION "COPY_16BIT",ROM0[8]       	;COPY BC
copybcloop:
	ld a,[hl+]
	ld [de],a
	inc de
	dec bc
	ld a,b
	or c
	jr nz,copybcloop
	ret

SECTION "rst 18",ROM0[$18]       	;set video bank
	ld [vramBank],a
	ld [rVBK],a
	ret

SECTION "rst 20",ROM0[$20]       	;set rom bank
	ld [romBank],a
	ld [rROMB0],a
	ret

SECTION "rst 28",ROM0[$28]       	;play sfx
	ld c,a
	ld a,[romBank]
	push af
	push bc
	SET_ROMBANK ROMBANK_SFX
	pop bc
	ld a,c
	call $4000
	pop af
	SET_ROMBANK a
	ret

SECTION "vblank",ROM0[$40]     ;vblank interrupt
        jp VblankInterrupt

SECTION "lcdc",ROM0[$48]       ;scanline interrupt
	jp $ff8a

ReadKeys::
	; returns A bits:
	; 7 - DOWN
	; 6 - UP
	; 5 - LEFT
	; 4 - RIGHT
	; 3 - START
	; 2 - SELECT
	; 1 - B
	; 0 - A

	ld a,%100000
	ld [rP1],a
	ld a,[rP1]
	ld a,[rP1]
	and $0f
	swap a
	ld b,a
	ld a,%10000
	ld [rP1],a
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	ld a,[rP1]
	and $0f
	or b
	ld b,a
	ld a,%110000
	ld [rP1],a

	ld a,[oldInput]
	ld c,a
	ld a,b
	cpl
	ld [oldInput],a
	xor c
	ld c,a
	ld a,b
	cpl
	ld b,a
	and c
	ld [inputMask],a
	ld a,b
	ret

 	db "            ToyToy+ . "
 	db "Programming - Tomasz Slanina . "
 	db "GFX - Adam Karol . "
 	db "Music - Krzysztof Wierzynkiewicz .   "

SECTION "HEADER",ROM0[$100]
    	nop
    	jp Start
    	ds 48	; Place for  header
    	db "TOYTOY ",0,0,0,0,"XXXX",$c0 ; Title
    	db 0,0,0
    	db $19 ; MBC5
    	db 5 ; ROM
    	db 0 ; RAM
    	db 0,0 ; Maker ID
    	db 2 ; Version number
 	db 0,0,0

Start:
	di
    	nop
    	ld sp,$cfff
 	ld hl,rKEY1
    	set 0,[hl]	
    	xor a
    	ld [rIF],a
    	ld [rIE],a
    	ld a,$30
    	ld [rP1],a
   	stop
    	nop
 	xor a
 	ld [musicBank],a ;set music off
	
	ld hl,SpriteDMA
	ld de ,_HRAM    ;copy sprite dma coe to hram
	ld c,SpriteDMAEnd-SpriteDMA
	COPY_8BIT

	call DisplayCredits
 
.main:
 	xor a
 	call StartMusic
	call TitleScreen
 	call GameStart
 	jr .main
	
GameStart:	

	xor a
restart:
	push af
	ld a,1
 	call StartMusic
 	pop af
 	
	call SetupLevel

	di
	nop
	xor a
	ld [rIF],a
	ld a,3
	ld [rIE],a
	
	ld hl,ScanlineGame
	call SetScanlineFunction
	
	ld a,64
	ld [rSTAT],a
	ld a,144-16
	ld [rLYC],a
	
	ei
	nop
.end:
	ld a,[vblankFlag]
	or a
	jr nz,.end
	cpl
	ld [vblankFlag],a
	ld a,128
	ld [rLYC],a
	
	ld a,[vblankCounter]
	and 3
	jr nz,.skipTimer
	
	ld a,[timer]
	dec a
	ld [timer],a
	jr nz,.skipTimer
	ld a,[time]
	dec a
	ld [time],a
	jr z,.gameover	
	
.skipTimer:	
	ld a,[flag]
	cp 1
	jr z,.gameover
	cp 2
	jr z,.nextlevel
		
	ld a,[shieldCounter]
	or a
	jr z,.skipShield
	dec a
	ld [shieldCounter],a

.skipShield:	
        call AiSprites
        call BuildSprites
	jr .end	
	
.gameover:
	call StopMusic
	ld c,60

.end2:
	ld a,[vblankFlag]
	or a
	jr nz,.end2
	cpl
	ld [vblankFlag],a

	ld a,128
	ld [rLYC],a
	dec c
	jr nz, .end2
	ld a,1
	jp Inter	
	
.nextlevel:
	call StopMusic
	ld c,60

.end2x:
	ld a,[vblankFlag]
	or a
	jr nz,.end2x
	cpl
	ld [vblankFlag],a
	ld a,128
	ld [rLYC],a
	dec c
	jr nz, .end2x
	ld a,[level]
	inc a
	cp 10
	jp c,restart
	ld a,2
	jp Inter
	
StopMusic:
	ld a,[romBank]
	push af
	SET_ROMBANK [musicBank]
	call $4006 
	pop af
	SET_ROMBANK a
	ret

StartMusic:
	add a,2
	ld [musicBank],a
	ld a,[romBank]
	push af
	SET_ROMBANK [musicBank]
	call $4000 
	call $4003 
	pop af
	SET_ROMBANK a
	ret	

VblankInterrupt:
	push af
	push bc
	push de
	push hl

	ld hl,rLCDC
	set 4,[hl]
	set 1,[hl]
	
	xor a
	ld [vblankFlag],a
	
	ld a,[vblankCounter]
	inc a
	ld [vblankCounter],a
	
	ld a,[scrollX]
	ld [rSCX],a
	ld a,[scrollY]
	ld [rSCY],a
	call _HRAM
	call RefreshStatusBar
	call UpdateAudio
	pop hl
	pop de
	pop bc
	pop af
	reti	

; a - level number
SetupLevel:

	ld [level],a
	xor a
	call Inter
	ld a,6
	ld [toysCounter],a
	ld a,3
	ld [playerEnergy],a
	xor a
	ld [shieldCounter],a
	ld [flag],a
	
	ld a,7
	ld [time],a
	xor a
	ld [timer],a

	ld a,[level]
	push af
	push af
	call SwitchLCDOff
	SET_VIDEOBANK 0
	SET_ROMBANK 1
	
	ld hl,gameTiles
	ld de,_VRAM
	ld bc, winTiles-gameTiles
	COPY_16BIT
	
	ld hl,winTiles
	ld de,_VRAM+$1000
	ld bc,gameBgPal - winTiles
	COPY_16BIT

	call MakeStatusBar
	
	ld hl,spriteTiles
	ld de,_VRAM
	ld bc, spriteTilesEnd - spriteTiles
	COPY_16BIT

	SET_VIDEOBANK 0
	
	ld hl,gameBgPal
	ld de,rBCPS
	ld a,128
	ld [de],a
	inc de
	ld c,64
.se1:
	ld a,[hl+]
	ld [de],a
	dec c
	jr nz,.se1

	ld hl,gameObjPal
	ld de,rOCPS
	ld a,128
	ld [de],a
	inc de
	ld c,64
.se2:
	ld a,[hl+]
	ld [de],a
	dec c
	jr nz,.se2

; levelloader	

	pop af
	add a,a
	add a,a
	add a,$40 
	ld h,a
	ld l,0
	push hl
	ld de,_SCRN0
	ld bc,$400
	
	SET_ROMBANK ROMBANK_MAPS
	COPY_16BIT

	SET_VIDEOBANK 1
	pop hl

	ld de,_SCRN0
	ld bc,$400
	SET_ROMBANK ROMBANK_ATTRIBS
	COPY_16BIT

	pop af
	push af
	add a,$70
	ld h,a
	ld l,0
	ld de,$d000
	ld bc,$100
	SET_ROMBANK ROMBANK_MAPS
	COPY_16BIT

	SET_ROMBANK 1
	
	pop af
	call InitializeSprites
	
	ld a,7
	ld [rWX],a
	ld a,144-16
	ld [rWY],a
	
	ld a,%11110111
	ld [rLCDC],a	
	ret


SetScanlineFunction::
	ld a,l
	ld [$ff8b],a
	ld a,h
	ld [$ff8c],a
	ret

SwitchLCDOff::
	xor a
	ld [rLCDC],a
	ret	

TimeLookupTable:
	db 22,22,22,22,22,22,0,0
	db 38,22,22,22,22,22,0,0	
	db 38,38,22,22,22,22,0,0	
	db 38,38,38,22,22,22,0,0	
	db 38,38,38,38,22,22,0,0	
	db 38,38,38,38,38,22,0,0	
	db 38,38,38,38,38,38,0,0	
		
RefreshStatusBar:
	xor a
	ld [rVBK],a

	ld a,[refresh]
	xor 1
	ld [refresh],a
	and 1
	jp z,.noRefresh
	
	;czas
	ld a,[time]
	and $f
	jr z,.skipdec
	dec a

.skipdec:	
	add a,a
	add a,a
	add a,a ; time *8
	ld hl,TimeLookupTable
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	
	ld de,_SCRN1+1
	push hl
	ld a,[hl+]
	ld [de],a
	inc de
	ld a,[hl+]
	ld [de],a
	inc de
	ld a,[hl+]
	ld [de],a
	inc de
	ld a,[hl+]
	ld [de],a
	inc de
	ld a,[hl+]
	ld [de],a
	inc de
	ld a,[hl]
	ld [de],a
	pop hl
	ld de,_SCRN1+1+32
	ld a,[hl+]
	inc a
	ld [de],a
	inc de
	ld a,[hl+]
	inc a
	ld [de],a
	inc de
	ld a,[hl+]
	inc a
	ld [de],a
	inc de
	ld a,[hl+]
	inc a
	ld [de],a
	inc de
	ld a,[hl+]
	inc a
	ld [de],a
	inc de
	ld a,[hl]
	inc a
	ld [de],a
	ret

.noRefresh:
	ld bc,32
	ld a,[toysCounter]
	or a
	jr z,.no
	dec a
	add a,a
	add 8
	ld hl,_SCRN1+18
	ld [hl],a
	add hl,bc
	inc a
	ld [hl],a
	
.no:	
	ld a,[playerEnergy]
	cp 3
	jr nz,.n1
	ld hl,_SCRN1+8
	ld a,24
	ld [hl+],a
	inc a
	ld [hl-],a
	inc a
	add hl,bc
	ld [hl+],a
	inc a
	ld [hl],a
	
	ld hl,_SCRN1+10
	ld a,24
	ld [hl+],a
	inc a
	ld [hl-],a
	inc a
	add hl,bc
	ld [hl+],a
	inc a
	ld [hl],a
	ret

.n1:
	cp 2
	jr nz,.n2
	ld hl,_SCRN1+8
	ld a,24
	ld [hl+],a
	inc a
	ld [hl-],a
	inc a
	add hl,bc
	ld [hl+],a
	inc a
	ld [hl],a
	
	ld hl,_SCRN1+10
	ld a,28
	ld [hl+],a
	inc a
	ld [hl-],a
	inc a
	add hl,bc
	ld [hl+],a
	inc a
	ld [hl],a
	ret

.n2:
	ld hl,_SCRN1+8
	ld a,28
	ld [hl+],a
	inc a
	ld [hl-],a
	inc a
	add hl,bc
	ld [hl+],a
	inc a
	ld [hl],a
	
	ld hl,_SCRN1+10
	ld a,28
	ld [hl+],a
	inc a
	ld [hl-],a
	inc a
	add hl,bc
	ld [hl+],a
	inc a
	ld [hl],a
	ret			
		
MakeStatusBar:	
	ld hl,_SCRN1
	ld a,36
	ld [hl],a
	ld hl,_SCRN1+7
	ld a,32
	ld [hl],a
	ld hl,_SCRN1+12
	ld [hl+],a
	xor a
	ld c,2
	ld [hl+],a
	add c
	ld [hl+],a
	add c
	ld [hl+],a
	add c
	ld [hl+],a
	ld a,32
	ld [hl+],a
	inc hl
	add c
	ld [hl],a
	
	ld hl,_SCRN1+32
	ld a,36+1
	ld [hl],a
	ld hl,_SCRN1+7+32
	ld a,32+1
	ld [hl],a
	ld hl,_SCRN1+12+32
	ld [hl+],a
	ld a,1
	ld c,2
	ld [hl+],a
	add c
	ld [hl+],a
	add c
	ld [hl+],a
	add c
	ld [hl+],a
	ld a,32+1
	ld [hl+],a
	inc hl
	add c
	ld [hl],a
	
	call RefreshStatusBar
	
	SET_VIDEOBANK 1
	
	ld hl,_SCRN1
	ld c,64
	ld a,5+128
.loop1:
	ld [hl+],a
	dec c
	jr nz,.loop1	
	ret
	
UpdateAudio::
	ld a,[romBank]
	push af
	ld a,[musicBank]
	or a
	jr z,.nomusic
	SET_ROMBANK [musicBank]
	call $4100 ;player update

.nomusic:
	SET_ROMBANK ROMBANK_SFX
	call $4006
	pop af
	SET_ROMBANK a
	ret

ScanlineGame:
	push af
	push hl
	ld a,[rLY]
	cp 128
	jr nz,.grad
	ld hl,rLCDC
	res 4,[hl]
	res 1,[hl]
	ld a,[rLYC]
	;ld [rLYC],a
	jr .kilo

.kix:	
	pop hl
	pop af
	reti

.grad:
	cp 144
	jr nc,.kix

.kilo:
	inc a
	ld [rLYC],a
	sub 129
	add a,a
	ld h,a
	add a,a
	add h
	ld h,a
	
	ld a,128+5*4*2+1*2
	ld [rBCPS],a
	ld a,h
	ld hl,colorGradient
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	
	WAIT_VRAM
	ld a,[hl+]
	ld [rBCPD],a
	ld a,[hl+]
	ld [rBCPD],a
	
	ld a,[hl+]
	ld [rBCPD],a
	ld a,[hl+]
	ld [rBCPD],a
	
	ld a,[hl+]
	ld [rBCPD],a
	ld a,[hl]
	ld [rBCPD],a

	pop hl
	pop af
	reti

COL: MACRO
	dw  (\1), (\1)*1024, ((\1))+((\1))*32+((\1)/2)*1024
ENDM		

colorGradient:
	COL 27
	COL 28
	COL 28
	COL 29
	COL 29
	COL 30
	COL 30
	COL 31
	COL 31
	COL 28
	COL 25
	COL 22
	COL 19
	COL 16
	COL 13
	COL 10
	COL 7
	COL 4
	COL 1
 
	COL 7
	COL 10
	COL 13
	COL 16
	COL 19
	COL 22
	COL 25
	COL 28
	COL 31
	COL 28
	COL 25
	COL 22
	COL 19
	COL 16
	COL 13
	COL 10
	COL 7
	COL 4
	COL 1
  
;copied to _HRAM
SpriteDMA:
    	ld a,$c0
    	ld [rDMA],a
    	ld a,40
.spr:
   	dec a
    	jr nz,.spr
    	ret
    	jp 0 ;filled later, LCDC interrupt jump
SpriteDMAEnd:	

spriteTiles:: 
 	INCLUDE "../data/sprite_tiles.inc"
spriteTilesEnd::

SECTION "BANK1", ROMX[$4000],BANK[1]
gameTiles:: 
 	INCLUDE "../data/game_tiles.inc" 
winTiles:: 
 	INCLUDE "../data/window_tiles.inc" 
gameBgPal:: 
 	INCLUDE "../data/game_bg_palette.inc" 
gameObjPal:: 
 	INCLUDE "../data/game_sprite_palette.inc" 
titleTiles::
 	INCLUDE "../data/title_tiles.inc" 
titleTilesEnd::

titleMap::
 	INCLUDE "../data/title_map.inc" 
titleMapEnd:: 

titleAttr::
 	INCLUDE "../data/title_attributes.inc" 
titleAttrEnd::

titlePalette::
 	INCLUDE "../data/title_palette.inc" 
titlePaletteEnd:

titleObjects::
 	INCLUDE "../data/title_sprites.inc" 
titleObjectsEnd::

SECTION "BANK10a", ROMX[$4000],BANK[ROMBANK_MAPS]
  	INCLUDE "../data/level0/map.inc"
  	INCLUDE "../data/level1/map.inc"
  	INCLUDE "../data/level2/map.inc"
  	INCLUDE "../data/level3/map.inc"
  	INCLUDE "../data/level4/map.inc"
  	INCLUDE "../data/level5/map.inc"
  	INCLUDE "../data/level6/map.inc"
  	INCLUDE "../data/level7/map.inc"
  	INCLUDE "../data/level8/map.inc"
  	INCLUDE "../data/level9/map.inc"

SECTION "BANK10b", ROMX[$7000],BANK[ROMBANK_MAPS]
	INCLUDE "../data/level0/collision.inc"
	INCLUDE "../data/level1/collision.inc"
	INCLUDE "../data/level2/collision.inc"
	INCLUDE "../data/level3/collision.inc"
	INCLUDE "../data/level4/collision.inc"
	INCLUDE "../data/level5/collision.inc"
	INCLUDE "../data/level6/collision.inc"
	INCLUDE "../data/level7/collision.inc"
	INCLUDE "../data/level8/collision.inc"
	INCLUDE "../data/level9/collision.inc"

SECTION "BANK10", ROMX[$4000],BANK[ROMBANK_ATTRIBS]
	INCLUDE "../data/level0/attributes.inc"
	INCLUDE "../data/level1/attributes.inc"
	INCLUDE "../data/level2/attributes.inc"
	INCLUDE "../data/level3/attributes.inc"
	INCLUDE "../data/level4/attributes.inc"
	INCLUDE "../data/level5/attributes.inc"
	INCLUDE "../data/level6/attributes.inc"
	INCLUDE "../data/level7/attributes.inc"
	INCLUDE "../data/level8/attributes.inc"
	INCLUDE "../data/level9/attributes.inc"

interm::
	INCLUDE "../data/info_map.inc"
intera::
	INCLUDE "../data/info_attributes.inc"
intert::
	INCLUDE "../data/info_tiles.inc"
interp::
	INCLUDE "../data/info_palette.inc"

SECTION "BANK2", ROMX[$4000],BANK[2] 
	INCBIN "../audio/title.bin" 

SECTION "BANK3", ROMX[$4000],BANK[3] 
	INCBIN "../audio/level.bin" 
	
SECTION "BANK4",ROMX[$4000],BANK[ROMBANK_DATA]           
	INCLUDE "../data/wobble.inc"

cR	SET 31
cG	SET 31
cB	SET  0
REPT	30
	dw cB*1024+cG*32+cR
	dw cB*1024+cG*32+cR
	dw cB*1024+cG*32+cR
cG	SET	cG+-1
ENDR

cR	SET 30
cG	SET  0	
cB	SET  0
REPT	31
	dw cB*1024+cG*32+cR
	dw cB*1024+cG*32+cR
	dw cB*1024+cG*32+cR
cR	SET	cR+-1
ENDR

stab::

REPT	4
	dw $ffff
ENDR

;cR	SET 31
cG	SET 31
cB	SET 31
REPT	10
	dw cB*1024+cG*32+cR
cG	SET	cG+-3
;cR	SET	cR+-4
;cB	SET	cB+-2
ENDR

dw 0,0,0,0,0,0,0,0

REPT	4
	dw $ffff
ENDR

;cR	SET 31
cG	SET 31
cB	SET 31
REPT	10
	dw cB*1024+cG*32+cR
cG	SET	cG+-3
;cR	SET	cR+-4
;cB	SET	cB+-2
ENDR


;credits
creditsMap::
	INCLUDE "../data/intro_map.inc"	
creditsAttr::
	INCLUDE "../data/intro_attributes.inc"	
creditsTiles::
	INCLUDE "../data/intro_tiles.inc"	
creditsPalette::
	INCLUDE "../data/intro_palette.inc"

SECTION "BANK8",ROMX[$4000],BANK[ROMBANK_SFX]  
	INCBIN "../audio/sfx.bin"	
 
SECTION "RAM", WRAM0[_RAM]

shadowOam           		DS $a0; sprite table
romBank				DS 1
vramBank			DS 1
musicBank			DS 1 ; 0 - no music
a_GLOBAL::			DS 16
oldInput			DS 1
inputMask::			DS 1
flash::				DS 1
stars::				DS 12*4
spriteTable::			DS 20*8
sprcnt::			DS 1
scrollX::			DS 1
scrollY::			DS 1 
vblankFlag			DS 1
vblankCounter::			DS 1
animationCounter::		DS 1
rand::				DS 1
oldPlayerX::			DS 1
oldPlayerY::			DS 1
newPlayerDirection::		DS 1
deltaX::			DS 1
deltaY::			DS 1

toysCounter::			DS 1
time::				DS 1
timer::				DS 1
playerEnergy::			DS 1
flag::				DS 1
shieldCounter::			DS 1
level::				DS 1
refresh::			DS 1
exitTitle::			DS 1
