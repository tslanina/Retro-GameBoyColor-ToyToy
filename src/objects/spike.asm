; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "Spike",ROM0

; shows and hides
; collides with player only in phase 3

AiSpike::
	ld a,[animationCounter]
	and 7
	jp nz,ContinueSpriteLoop

	push hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	
	inc hl
	ld a,[hl]
	inc a
	and 31
	ld [hl-],a
	push hl
	ld hl,spikeFrame
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	ld a,[hl]
	pop hl
	ld [hl],a	

	pop hl		
	push af
	push hl
	call MakeSpriteTile
	pop hl
	pop af
	
	cp 3
	jp nz,ContinueSpriteLoop
	
	; check collision with player only in phase 3
	push hl
	call PlayerCollision
	pop hl

	call nz, DecrementPlayerEnergy
	
	jp ContinueSpriteLoop

spikeFrame:
 db 0,0,0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

