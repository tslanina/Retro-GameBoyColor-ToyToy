; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

MAXX equ (256-160)
MAX2 equ 80
MINX equ 0

MAXY equ (256-144+16)
MAY2 equ 72
MINY equ 0

SECTION "Player",ROM0

AiPlayer::
	push hl
	call ReadKeys
	
	pop hl
	ld c,$ff        
	ld de,0
        bit 7,a
        jr z,.notDown
        ld c,3
        ld e,1
        jr .movePlayer
.notDown:  

	bit 6,a
	jr z,.notUp
	ld c,2
	ld e,-1
	jr .movePlayer
.notUp:  

	bit 5,a
        jr z,.notLeft
	ld c,0
	ld d,-1
	jr .movePlayer
.notLeft:
	bit 4,a
	jr z,.movePlayer
	ld c,1
	ld d,1
.movePlayer:
	ld a,c
	cp $ff 
	jp z,ContinueSpriteLoop
	
	;there's move to perform, de = step xy, c = direction
	ld a,d
	ld [deltaX],a
	ld a,e
	ld [deltaY],a
	
	ld a,c
	ld [newPlayerDirection],a
	push hl
	inc hl
	ld a,[hl]
	ld [oldPlayerY],a
	add e
	ld [hl+],a
	
	ld a,[hl]
	ld [oldPlayerX],a
	add d
	ld [hl],a
	
	pop hl
	push hl
	
	call MapCollisionPlayer
	jr z,.psox
	pop hl
	push hl
	
	inc hl
	ld a,[oldPlayerY]
	ld [hl+],a
	ld a,[oldPlayerX]
	ld [hl+],a
	jr .bigSkip

.psox:	
	pop hl
	push hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a,[newPlayerDirection]
	ld [hl],a
	
	;modify screen scroll parameters
	ld a,[deltaX]
	ld c,a
	
	cp 1
	jr nz,.no_1
	
	ld a,[scrollX]
	cp MAXX
	jr z,.no_2
	
	ld b,a
	ld a,[spriteTable+2]
	sub b
	cp MAX2
	jr c,.no_2
	inc b
	ld a,b
	ld [scrollX],a

	jr .no_2

.no_1:
	cp -1
	jr nz,.no_2
	
	ld a,[scrollX]
	cp MINX
	jr z,.no_2
	
	ld b,a
	ld a,[spriteTable+2]
	sub b
	cp MAX2
	jr nc,.no_2
	dec b
	ld a,b
	ld [scrollX],a

.no_2:	
	ld a,[deltaY]
	ld c,a
	
	cp 1
	jr nz,.no_1y
	
	ld a,[scrollY]
	cp MAXY
	jr z,.bigSkip
	
	ld b,a
	ld a,[spriteTable+1]
	sub b
	cp MAY2
	jr c,.bigSkip
	inc b
	ld a,b
	ld [scrollY],a
	jr .bigSkip

.no_1y:
	cp -1
	jr nz,.bigSkip
	
	ld a,[scrollY]
	cp MINY
	jr z,.bigSkip
	ld b,a
	ld a,[spriteTable+1]
	sub b
	cp MAY2
	jr nc,.bigSkip
	dec b
	ld a,b
	ld [scrollY],a
	
.bigSkip:  	
	pop hl
	push hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a,[animationCounter]
	srl a
	srl a
	srl a
	and 1
	ld [hl],a
	pop hl
	call  MakeSpriteTile
	
	jp ContinueSpriteLoop
