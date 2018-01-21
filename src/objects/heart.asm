; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "Heart",ROM0

;just animates....

AiHeart::
	ld a,[animationCounter]
	and 7
	jp nz,ContinueSpriteLoop
	push hl
	ld a,[animationCounter]
	srl a
	srl a
	srl a
	and 15
	
	ld hl,heartTab
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	ld c,[hl]
	pop hl
	push hl
	
	inc hl
	ld a,[hl]
	and $f8
	or c
	ld [hl],a
	
	pop hl
	push hl
	call PlayerCollision
	pop hl
	jp z,ContinueSpriteLoop
	
	xor a
	ld [hl],a ; remove
	
	call IncrementPlayerEnergy
	
	jp ContinueSpriteLoop

heartTab:
db 0,0,1,1,1,2,2,3,3,2,2,1,1,1,0,0,0,0,0
