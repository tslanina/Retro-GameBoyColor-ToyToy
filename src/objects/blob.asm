; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "Blob",ROM0

; moves. On wall collision randomly changes direction

AiBlob::
	ld a,[animationCounter]
	and 1
	cp 1
	jp nz,ContinueSpriteLoop	
	push hl
	ld bc,7
	add hl,bc ;v0
	ld a,[hl]
	pop hl
	
	or a
	jr z,.horizontal_left
	cp 1
	jr z,.vertical_down
	cp 3
	jr z,.horizontal_right

;vertical up
	inc hl
	ld a,[hl]
	dec a
	ld [hl-],a
	push hl	
	call MapCollision
	pop hl
	jr z,.nextfr
	inc hl
	ld a,[hl]
	inc a ;restore old
	ld [hl-],a
	ld a,1
	jr .changeDirection

.vertical_down:	
	inc hl
	ld a,[hl]
	inc a
	ld [hl-],a
	push hl	
	call MapCollision
	pop hl
	jr z,.nextfr
	inc hl
	ld a,[hl]
	dec a ;restore old
	ld [hl-],a
	ld a,4
	jr .changeDirection

.horizontal_left:
	inc hl
	inc hl
	ld a,[hl]
	dec a
	ld [hl-],a
	dec hl
	push hl	
	call MapCollision
	pop hl
	jr z,.nextfr
	inc hl
	inc hl
	ld a,[hl]
	inc a ;restore old
	ld [hl-],a
	dec hl
	ld a,3
	jr .changeDirection

.horizontal_right:	
	inc hl
	inc hl
	ld a,[hl]
	inc a
	ld [hl-],a
	dec hl
	push hl	
	call MapCollision
	pop hl
	jr z,.nextfr
	inc hl
	inc hl
	ld a,[hl]
	dec a ;restore old
	ld [hl-],a
	dec hl
	xor a

.changeDirection:
	;hl points to start
	push hl
	ld bc,7
	add hl,bc

	call GetRandom
	and 3

	ld [hl],a
	pop hl

.nextfr:
	push hl
	ld bc,6
	add hl,bc
	ld a,[animationCounter]
	srl a
	srl a
	srl a
	srl a
	and 1
	ld [hl],a	
	pop hl
	
	push hl
	inc hl
	ld a,[hl+]
	or [hl]
	and 7
	pop hl
	
	jr nz,.noChange
	ld a,[rDIV]
	swap a
	cpl
	rlca
	and 31
	jr z,.changeDirection

.noChange:
	push hl
	call MakeSpriteTile
	pop hl
	
	push hl
	call PlayerCollision
	pop hl
	
	call nz,DecrementPlayerEnergy
	jp ContinueSpriteLoop
