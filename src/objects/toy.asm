; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

IS_REMOVING equ 131

SECTION "Toy",ROM0

;static and flashing toy

AiToy::
	push hl
	inc hl ;y
	inc hl ;x 
	inc hl ;tile
	inc hl ;attr
	
	inc hl
	ld a,[hl-]
	cp IS_REMOVING
	jr z,.noColorFlash
	
	ld a,[animationCounter]
	and 16
	ld c,3
	jr z,.skip1

.noColorFlash:	
	push hl
	inc hl
	inc hl
	inc hl
	ld c,[hl]
	pop hl
	
.skip1:
	ld a,[hl]
	and $f8
	or c
	ld [hl],a
	pop hl
	push hl ;start
	
	ld bc,5
	add hl,bc
	ld a,[hl]
	
	pop hl
	push hl 
	cp IS_REMOVING
	jr z,.remove

	call PlayerCollision
	pop hl
	jp z,ContinueSpriteLoop
	
	push hl
	
	ld bc,5
	add hl,bc
	ld a,IS_REMOVING
	ld [hl+],a
	
	push hl
	ld bc,-4 
	add hl,bc
	ld a,[hl]
	pop hl
	ld [hl],a
	pop hl
	call DecrementToysCounter
	jp ContinueSpriteLoop

.remove:
	inc hl   ;hl = y
	ld a,[hl]
	cp 252-16
	jr c,.noclear

	dec hl	    ;type	
	xor a
	ld [hl],a
	pop hl
	jp ContinueSpriteLoop

.noclear:		   
	add a,2
	;inc a
	ld [hl+],a
	srl a
	and 31
	push hl     ;hl =x  
	ld hl,sinToy
	add a,l
	ld l,a
	ld a,h
	adc 0
	ld h,a
	ld d,[hl] ;dx
	sra d
	sra d
	pop hl
	push hl   ;hl =x
	
	ld bc,4
	add hl,bc
	ld a,[hl]  ;hl =frame
	pop hl
	add d
	ld  [hl],a  ;hl =x	
		
	pop hl
	jp ContinueSpriteLoop

sinToy:
	db 0,4,9,13,16,19,22,23,23,23,22,19,16,13,9,4,0,-4,-9,-13,-16,-19,-22,-23,-23,-23,-22,-19,-17,-13,-9,-4,
