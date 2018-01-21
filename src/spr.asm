; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "Spr",ROM0

; Sprite fomat
; 0 = Type
;
;  76543 210
;  ||||| |||
;  ||||| ------ Subtype
;  ||||| Flags:
;  ||||-------- Player     8
;  |||--------- Toy   	  16
;  ||---------- Heart     32
;  |----------- Bonus     64
;  ------------ Enemy    128
;
;  Subtype:	
;	
;		 0 - blob
;		 1 - ball
;		 2 - chicken
;		 3 - spike
;
;		 0 - teddy
;		 1 - clown	
;		 2 - cube
;		 3 - bak	
;		
;		 0 - rabbit
;		 1 - trumpet
;		 2 - shield
;
; Bytes at offset 1-4 are copied to OAM
;
; 1 = y coordinate
; 2 = x coordinate
; 3 = tile (calculated, based on direction, type and frame)
; 4 = palette
;
; 5 = direction
; 6 = frame
; 7 = variable (usage depends on type)

BuildSprites::
	call buildSpritesInternal
	ld a,[shieldCounter]
	and 8
	ret z
	
	ld hl,$c000
	ld a,[sprcnt]
	and 1
	jr nz,.no1
	ld hl,$c000+38*4
.no1:	
	xor a
	ld [hl+],a
	ld [hl+],a
	inc hl
	inc hl
	ld [hl+],a
	ld [hl+],a
	
	ret

buildSpritesInternal:

	;build OAM
	ld a,[sprcnt]
	inc a
	ld [sprcnt],a	
	and 1
	jp z,reverseOrder
	
	ld hl,spriteTable
	ld de,$c000
	ld c,20
	
.mainLoop:	
	push bc
	push hl
	ld a,[hl+]
	or a
	jr z,.unused
	
	ld a,[scrollX]
	ld c,a
	ld a,[scrollY]
	ld b,a
	
	ld a,[hl+]
	sub b
	add 16 ;fix
	ld [de],a
	ld b,a
	inc de	;x
	
	ld a,[hl+]
	sub c
	add 8 ;fix
	ld [de],a
	ld c,a
	inc de 	;tile
	
	ld a,[hl+]
	ld [de],a  ; tile number on stack
	push af
	inc de ; attrib
	ld a,[hl]
	ld [de],a          
	inc de ; y2
	push af
	
	ld a,b
	ld [de],a      
	inc de ; x2
	ld a,c
	add 8 ; next 
	ld [de],a     
	inc de ; t2
	
	pop af          
	ld c,a
	pop af
	add 2 ; tile 2 next
	ld [de],a
	inc de          
	ld a,c
	ld [de],a
	inc de
	
	jr .skipnext

.unused:
	
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de
	
	ld [de],a ; remove second
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de

.skipnext:	
	pop hl
	ld bc,8
	add hl,bc	
	;xor a
	
	pop bc
	dec c
	jr nz,.mainLoop

	ret	
	
reverseOrder:	
	
	ld hl,spriteTable+19*8 ; end of sprite table
	ld de,$c000
	ld c,20
	
.mainLoop:	
	push bc
	push hl
	ld a,[hl+]
	or a
	jr z,.unused
	
	ld a,[scrollX]
	ld c,a
	ld a,[scrollY]
	ld b,a
	
	ld a,[hl+]
	sub b
	add 16 ;fix
	ld [de],a
	ld b,a
	inc de ; x
	
	ld a,[hl+]
	sub c
	add 8 ;fix
	ld [de],a
	ld c,a
	inc de  ; tile
	
	ld a,[hl+]
	ld [de],a ; tile number on stack
	push af
	inc de ; attrib
	ld a,[hl]
	ld [de],a          
	inc de  ; y2
	push af
	
	ld a,b
	ld [de],a      
	inc de  ;x2
	ld a,c
	add 8
	ld [de],a     
	inc de 
	
	pop af          
	ld c,a
	pop af
	add 2 ;tile 2 next
	ld [de],a
	inc de          
	ld a,c
	ld [de],a
	inc de
	
	jr .skipnext

.unused:
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de
	
	ld [de],a ; remove second
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	inc de

.skipnext:	
	pop hl
	ld bc,-8
	add hl,bc	
	;xor a
	
	pop bc
	dec c
	jr nz,.mainLoop
	ret	
	
InitializeSprites::

	push af
	ld hl,LevelInfo
	add a,a
	add a,a
	
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	
	ld a,[hl+]
	ld [scrollX],a	
	ld a,[hl+]
	ld [scrollY],a	
	
	ld de,spriteTable
	ld a,8
	ld [de],a
	inc de
	ld a,[hl+]; y
	ld [de],a
	inc de
	ld a,[hl]
	ld [de],a ;x
	inc de
	inc de
	ld a,9
	ld [de],a ; pal
	
	inc de
	ld a,3
	ld [de],a ; dir
	xor a
	inc de
	ld [de],a ; v0

	ld hl,spriteTable
	call MakeSpriteTile		
	
	pop af
	ld hl,Objtable
	add a,a
	;add a,a
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	ld a,[hl+]
	ld h,[hl]
	ld l,a
	
	ld de,spriteTable+8

	ld c,19
	push de
	xor a
.loopa:	
	ld [de],a ; clear	
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	dec c
	jr nz,.loopa	
	pop de

.sprloop:	
	
	ld a,[hl+]
	or a
	jr z,.exit 
	
	ld [de],a ;typ
	inc de
	ld a,[hl+]
	ld [de],a ;y
	inc de
	ld a,[hl+]
	ld [de],a ;x
	inc de
	ld a,[hl+]
	ld [de],a ;tile
	inc de
	ld a,[hl+]
	add 8 ;BANK!
	ld [de],a ;pal
	inc de
	xor a
	ld [de],a ;dir
	inc de
	ld a,[hl+]
	inc de
	ld [de],a ;v0
	inc de
	jr .sprloop
	
.exit:
	call BuildSprites
	ret
	
AiSprites:: 
	ld a,[animationCounter]
	inc a
	ld [animationCounter],a
	ld hl,spriteTable
	ld c,20

lopab:
	push hl
	push bc		
	ld a,[hl]
	or a
	jp z,ContinueSpriteLoop
	cp 8
	jp z,AiPlayer
	cp 131
	jp z,AiSpike
	cp 128 
	jp z,AiBlob
	cp 129
	jp z,AiBall		
	bit 4,a
	jp nz,AiToy
	bit 5,a
	jp nz,AiHeart

ContinueSpriteLoop::
	pop bc
	pop hl
	ld de,8
	add hl,de
	dec c
	jr nz,lopab
	ret	

CHECKBC: MACRO
	push bc
	ld a,c
	and $f0	
	ld c,a
	ld a,b  ;x
	swap a
	and 15
	or c 
	push hl
	add a,l
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	ld a,[hl]
	pop hl
	pop bc
	or a
	ret nz
ENDM

MapCollision::

	inc hl
	ld a,[hl+]
	ld c,a
	ld a,[hl]
	ld b,a
	ld hl,$d000

	CHECKBC 

	ld a,15
	add c
	ld c,a

	CHECKBC

	ld a,15
	add b
	ld b,a

	CHECKBC

	ld a,c
	sub 15
	ld c,a

	CHECKBC

	xor a
	ret
	
MapCollisionPlayer::

	inc hl
	ld a,[hl+]
	add 3
	ld c,a
	ld a,[hl]
	add 3
	ld b,a
	ld hl,$d000

	CHECKBC

	ld a,9
	add c
	ld c,a

	CHECKBC

	ld a,9
	add b
	ld b,a

	CHECKBC

	ld a,c
	sub 9
	ld c,a

	CHECKBC

	xor a
	ret	

	
MakeSpriteTile:: 
	ld a,[hl+]
	or a
	ret z
	bit 3,a
	jr z,.notPlayer

	inc hl ;2
	inc hl
	inc hl
	inc hl ;5
	ld a,[hl+] ;dir
	add a,a
	ld c,[hl]  ;frame
	add a,c
	
	add a,a
	add a,a
	dec hl
	dec hl
	dec hl

	ld [hl],a
	ret

.notPlayer:	
	ld b,a
	inc hl ;2
	inc hl
	inc hl
	inc hl ;5
	inc hl
	ld a,[hl-]
	dec hl
	dec hl
	add a,a
	add a,a  ;*4
	ld c,a
	ld a,b
	bit 7,a
	ret z  ;bonuses and toys has fixed tile num (not animated)
	and 7
	or a
	jr nz,.notBlob
	ld a,32
	jr .write

.notBlob:
	cp 1
	jr nz,.notBall	
	ld a,40
	jr .write

.notBall:
	ld a,64	;spike
	jr .write

.write:
	add c
	ld [hl],a
	ret	
	
GetRandom::
	ld a,[vblankCounter]
	swap a
	rlca 
	ld b,a
	
	ld a,[rDIV]
	cpl
	swap a
	ld c,a
	ld a,[rand]
	xor c
	rlca
	rlca
	xor b
	swap a
	rlca
	ld [rand],a
	ret

PlayerCollision::
	inc hl
	ld a,[hl+] ;y
	add 2
	ld b,a
	add 2
	ld c,[hl] ;x
	ld a,[spriteTable+2]
	add 2
	ld e,a
	add 16-5 
	cp c
	jr c,.no
	
	ld a,c
	add 16-5
	cp e
	jr c,.no
	
	ld a,[spriteTable+1]
	add 2
	ld e,a
	add 16-5
	cp b
	jr c,.no
	
	ld a,b
	add 16-5
	cp e
	jr c,.no
	ld a,1
	or a
	ret
.no:	
	xor a
	ret
	
DecrementPlayerEnergy::
	ld a,[shieldCounter]
	or a
	ret nz
	
	ld a,128
	ld [shieldCounter],a

	ld a,[playerEnergy]
	dec a
	ld [playerEnergy],a 
	or a
	jr nz,.skip
	ld a,1
	ld [flag],a

.skip:	
	PLAY_SFX 1
	ret
	
IncrementPlayerEnergy::
	ld a,3
	ld [playerEnergy],a
	
	PLAY_SFX 0
	ret	

DecrementToysCounter::
	ld a,[toysCounter]
	dec a
	ld [toysCounter],a
	or a
	jr nz,.skip
	ld a,2
	ld [flag],a
.skip:
	PLAY_SFX 2
	ret	

