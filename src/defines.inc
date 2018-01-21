; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

ROMBANK_DATA 			equ 4
ROMBANK_CREDITS 		equ ROMBANK_DATA
ROMBANK_MAPS 			equ 5
ROMBANK_SFX 			equ 6
ROMBANK_ATTRIBS 		equ 7
ROMBANK_INTER 			equ ROMBANK_ATTRIBS

_RAM 				equ  $c000
_SCRN1        			equ  $9c00
_VRAM         			equ  $8000
_HRAM         			equ  $ff80 
_SCRN0        			equ  $9800

rROMB0        			equ $2000
rP1 				equ $ff00
rDIV 				equ $ff04
rIF 				equ $ff0f
rLCDC 				equ $ff40
rSTAT 				equ $ff41
rSCY  				equ $ff42
rSCX  				equ $ff43
rLY 				equ $ff44
rLYC  				equ $ff45
rDMA  				equ $ff46
rWY 				equ $ff4a
rWX 				equ $ff4b
rKEY1 				equ $ff4d
rVBK 				equ $ff4f
rBCPS 				equ $ff68
rBCPD 				equ $ff69
rOCPS 				equ $ff6a
rOCPD 				equ $ff6b
rIE 				equ $ffff

SET_VIDEOBANK: MACRO
	ld a,\1
	rst $18
ENDM

SET_ROMBANK: MACRO
	ld a,\1
	rst $20
ENDM

PLAY_SFX: MACRO
	ld a,\1
	rst $28
ENDM

COPY_8BIT: MACRO
	rst 0
ENDM

COPY_16BIT: MACRO
	rst 8
ENDM

WAIT_VRAM: MACRO
.www\@:
    ld a,[rSTAT]
    bit 1,a
    jr nz,.www\@
ENDM    
