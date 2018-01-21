; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "Ball",ROM0

; moves horizontally OR vertically. On wall collision flips movement direction
; 0 - left
; 1 - down
; 2 - N/A
; 3 - right
; 4 - up

AiBall::
	push hl
	ld bc,7
	add hl,bc ;variable - direction of movement
	ld a,[hl]
	add a,a
	add a,a ; *4
	ld c,a
	ld hl, ballTable
	add hl,bc
	push hl
	pop de ; de points to dy in the ballTable
	pop hl; poc
	inc hl
	ld a,[de]
	or a
	jr z,.horizontal

	ld c,a
	ld a,[hl]
	add a,c
	ld [hl-],a
	push hl
	push bc
	push de
	call MapCollision
	pop de
	pop bc
	pop hl
	jr z,.nextFrame

	push hl
	inc de ; dx
	inc de ; new direction
	ld a,[de]
	ld bc,7
	add hl,bc
	ld [hl],a ; store new direction in variable
	pop hl
	jr .nextFrame

.horizontal:
	inc hl ;x
	inc de
	ld a,[de]
	ld c,[hl]
	add a,c
	ld [hl-],a
	dec hl ;po
	push hl
	push bc
	push de
	call MapCollision
	pop de
	pop bc
	pop hl

	jr z,.nextFrame
	push hl
	inc de ; new direction
	ld a,[de]
	ld bc,7
	add hl,bc
	ld [hl],a ; store new direction in variable
	pop hl

.nextFrame:
	push hl
	ld bc,6
	add hl,bc ; hl points to frame
	ld a,[animationCounter]
	swap a ; /16
	and 1
	ld [hl],a	
	pop hl
	push hl
	call MakeSpriteTile
	pop hl
	
	push hl
	call PlayerCollision
	pop hl	
	call nz,DecrementPlayerEnergy
.finish:
	jp ContinueSpriteLoop
	
; format:  dy,dx, new direction, 0 (align)

ballTable:
	db 0,-1,3,0
	db 1,0,4,0
	db 0,0,0,0
	db 0,1,0,0
	db -1,0,1,0

