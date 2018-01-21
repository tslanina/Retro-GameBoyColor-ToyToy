; ToyToy GBC v1.2
; (c) 2003-2018 Tomasz Slanina

INCLUDE "defines.inc"

SECTION "Objects",ROM0

OBJECT_CUBE: MACRO
  db 18, \1, \2, 88,6,6
ENDM

OBJECT_SPIN: MACRO
  db 19, \1, \2, 84,6,6
ENDM

OBJECT_HEART: MACRO
  db 32, \1, \2, 80,6,6
ENDM

OBJECT_TRUMPET: MACRO
  db 21, \1, \2, 96,7,7
ENDM

OBJECT_RABBIT: MACRO
  db 20, \1, \2, 92,7,7
ENDM

OBJECT_CLOWN: MACRO
  db 17, \1, \2, 108,6,6
ENDM

OBJECT_TEDDY: MACRO
  db 16, \1, \2, 100,5,5
ENDM

OBJECT_BALL: MACRO
  db 129, \1, \2, 40,2, \3
ENDM

OBJECT_BLOB: MACRO
  db 128, \1, \2, 32,0, \3
ENDM

OBJECT_SPIKES: MACRO
  db 131, \1, \2, 64,4, \3
ENDM

OBJECT_END: MACRO
  db 0
ENDM

LevelInfo::
  db $2f ;scx
  db $4f ;scy
  db 15*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 15*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 10*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 15*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 15*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db 32 ;scy
  db 15*8-6*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 15*8+8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db 32 ;scy
  db 15*8-32  ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 15*8 ;y
  db 15*8 ;x
  
  db $2f ;scx
  db $4f ;scy
  db 15*8 ;y
  db 15*8 ;x

; y, x , tile, pal , v0

Objtable::
  dw obj_l0
  dw obj_l1
  dw obj_l2
  dw obj_l3
  dw obj_l4
  dw obj_l5
  dw obj_l6
  dw obj_l7
  dw obj_l8
  dw obj_l9

obj_l0:
  OBJECT_BALL     $10, $78, 0
  OBJECT_TRUMPET  $30, $30
  OBJECT_SPIKES   $30, $50, 9
  OBJECT_SPIKES   $30, $a0, 3
  OBJECT_BLOB     $40, $e0, 1
  OBJECT_CUBE     $48, $78
  OBJECT_BLOB     $50, $10, 1
  OBJECT_BALL     $50, $a0, 1
  OBJECT_SPIKES   $78, $10, 30
  OBJECT_TEDDY    $78, $28
  OBJECT_CLOWN    $78, $c8
  OBJECT_SPIKES   $78, $e0, 4
  OBJECT_SPIKES   $a0, $50, 1
  OBJECT_SPIKES   $a0, $a0, 12
  OBJECT_RABBIT   $c0, $10
  OBJECT_BLOB     $c0, $30, 0
  OBJECT_HEART    $c0, $e0
  OBJECT_SPIN     $d8, $78
  OBJECT_BALL     $e0, $c0, 0
  OBJECT_END

obj_l1:
  OBJECT_RABBIT   $10, $10
  OBJECT_SPIKES   $10, $50, 22
  OBJECT_SPIKES   $10, $a0, 14
  OBJECT_BLOB     $20, $78, 0
  OBJECT_TRUMPET  $30, $30
  OBJECT_TEDDY    $30, $c0
  OBJECT_BLOB     $30, $e0, 1
  OBJECT_BALL     $50, $30, 1
  OBJECT_BALL     $50, $c0, 1
  OBJECT_HEART    $70, $10
  OBJECT_SPIKES   $90, $20, 18
  OBJECT_SPIKES   $90, $d0, 16
  OBJECT_BALL     $a0, $78, 0
  OBJECT_CLOWN    $c0, $30
  OBJECT_SPIKES   $c0, $50, 9
  OBJECT_SPIKES   $c0, $a0, 17
  OBJECT_CUBE     $c0, $c0
  OBJECT_BLOB     $d0, $10, 1
  OBJECT_SPIN     $e0, $e0
  OBJECT_END

obj_l2:
  OBJECT_BLOB     $10, $c0, 0
  OBJECT_SPIKES   $30, $78, 17
  OBJECT_BLOB     $50, $10, 1
  OBJECT_SPIKES   $50, $30, 27
  OBJECT_CUBE     $50, $50
  OBJECT_TEDDY    $50, $a0
  OBJECT_SPIKES   $50, $c0, 9
  OBJECT_BALL     $50, $e0, 1
  OBJECT_BALL     $70, $a8, 0
  OBJECT_BALL     $80, $48, 0
  OBJECT_HEART    $a0, $10
  OBJECT_SPIKES   $a0, $30, 11
  OBJECT_CLOWN    $a0, $50
  OBJECT_TRUMPET  $a0, $a0
  OBJECT_SPIKES   $a0, $c0, 19
  OBJECT_SPIKES   $c0, $78, 6
  OBJECT_SPIN     $e0, $10
  OBJECT_BLOB     $e0, $30, 0
  OBJECT_RABBIT   $e0, $e0
  OBJECT_END

obj_l3:
  OBJECT_BLOB     $10, $78, 0
  OBJECT_BALL     $10, $a0, 1
  OBJECT_SPIKES   $30, $10, 27
  OBJECT_CUBE     $30, $30
  OBJECT_CLOWN    $30, $c0
  OBJECT_SPIKES   $30, $e0, 28
  OBJECT_HEART    $50, $e0
  OBJECT_BLOB     $70, $30, 1
  OBJECT_BLOB     $70, $c0, 1
  OBJECT_SPIKES   $a0, $30, 7
  OBJECT_TEDDY    $a0, $50
  OBJECT_TRUMPET  $a0, $a0
  OBJECT_SPIKES   $a0, $c0, 12
  OBJECT_RABBIT   $c0, $10
  OBJECT_BALL     $c0, $80, 0
  OBJECT_SPIN     $c0, $e0
  OBJECT_SPIKES   $e0, $50, 30
  OBJECT_BALL     $e0, $70, 0
  OBJECT_SPIKES   $e0, $a0, 25
  OBJECT_END

obj_l4:
  OBJECT_BLOB     $10, $10, 1
  OBJECT_SPIKES   $10, $78, 4
  OBJECT_BALL     $10, $e0, 1
  OBJECT_TRUMPET  $30, $30
  OBJECT_BLOB     $30, $78, 0
  OBJECT_TEDDY    $30, $c0
  OBJECT_HEART    $50, $50
  OBJECT_SPIKES   $50, $78, 30
  OBJECT_RABBIT   $70, $10
  OBJECT_SPIN     $70, $e0
  OBJECT_SPIKES   $78, $30, 13
  OBJECT_SPIKES   $78, $c0, 28
  OBJECT_SPIKES   $a0, $78, 6
  OBJECT_CLOWN    $c0, $30
  OBJECT_BALL     $c0, $78, 0
  OBJECT_CUBE     $c0, $c0
  OBJECT_BALL     $e0, $10, 1
  OBJECT_SPIKES   $e0, $78, 23
  OBJECT_BLOB     $e0, $e0, 1
  OBJECT_END

obj_l5:
  OBJECT_SPIKES   $10, $50, 7
  OBJECT_SPIKES   $10, $a0, 30
  OBJECT_BLOB     $30, $10, 1
  OBJECT_CLOWN    $30, $30
  OBJECT_BLOB     $30, $78, 0
  OBJECT_TEDDY    $30, $c0
  OBJECT_BLOB     $30, $e0, 1
  OBJECT_BALL     $70, $10, 1
  OBJECT_SPIKES   $70, $e0, 19
  OBJECT_SPIKES   $80, $10, 18
  OBJECT_BALL     $80, $78, 0
  OBJECT_BALL     $80, $e0, 1
  OBJECT_CUBE     $a0, $30
  OBJECT_TRUMPET  $a0, $c0
  OBJECT_SPIKES   $c0, $50, 13
  OBJECT_HEART    $c0, $a0
  OBJECT_SPIKES   $c0, $e0, 8
  OBJECT_SPIN     $e0, $10
  OBJECT_RABBIT   $e0, $e0
  OBJECT_END

obj_l6:
  OBJECT_TEDDY    $10, $10
  OBJECT_SPIKES   $10, $50, 3
  OBJECT_SPIKES   $10, $a0, 27
  OBJECT_CUBE     $10, $e0
  OBJECT_BALL     $30, $50, 1
  OBJECT_BLOB     $30, $a0, 1
  OBJECT_SPIKES   $70, $50, 11
  OBJECT_BALL     $70, $78, 0
  OBJECT_SPIKES   $70, $a0, 6
  OBJECT_RABBIT   $a0, $10
  OBJECT_SPIN     $a0, $e0
  OBJECT_SPIKES   $c0, $10, 31
  OBJECT_TRUMPET  $c0, $30
  OBJECT_BLOB     $c0, $50, 1
  OBJECT_BALL     $c0, $a0, 1
  OBJECT_CLOWN    $c0, $c0
  OBJECT_SPIKES   $c0, $e0, 3
  OBJECT_HEART    $e0, $10
  OBJECT_BLOB     $e0, $78, 0
  OBJECT_END

obj_l7:
  OBJECT_SPIKES   $10, $10, 26
  OBJECT_HEART    $10, $c0
  OBJECT_SPIKES   $10, $e0, 29
  OBJECT_BALL     $30, $78, 0
  OBJECT_TEDDY    $50, $30
  OBJECT_TRUMPET  $50, $c0
  OBJECT_BLOB     $70, $20, 1
  OBJECT_BLOB     $70, $78, 0
  OBJECT_BLOB     $70, $d0, 1
  OBJECT_CUBE     $a0, $10
  OBJECT_SPIKES   $a0, $30, 9
  OBJECT_BALL     $a0, $78, 0
  OBJECT_SPIKES   $a0, $c0, 24
  OBJECT_CLOWN    $a0, $e0
  OBJECT_SPIKES   $b0, $10, 5
  OBJECT_SPIKES   $b0, $e0, 31
  OBJECT_BALL     $c0, $78, 0
  OBJECT_RABBIT   $e0, 50
  OBJECT_SPIN     $e0, $a0
  OBJECT_END

obj_l8:
  OBJECT_SPIKES   $10, $30, 29
  OBJECT_BALL     $10, $78, 0
  OBJECT_SPIKES   $10, $c0, 20
  OBJECT_TEDDY    $30, $30
  OBJECT_TRUMPET  $30, $c0
  OBJECT_BLOB     $50, $10, 0
  OBJECT_RABBIT   $70, $30
  OBJECT_BALL     $70, $50, 1
  OBJECT_BLOB     $70, $a0, 1
  OBJECT_SPIN     $70, $c0
  OBJECT_SPIKES   $78, $10, 11
  OBJECT_SPIKES   $78, $e0, 28
  OBJECT_HEART    $a0, $10
  OBJECT_BLOB     $a0, $e0, 0
  OBJECT_CLOWN    $c0, $30
  OBJECT_CUBE     $c0, $c0
  OBJECT_SPIKES   $e0, $50, 22
  OBJECT_BALL     $e0, $78, 0
  OBJECT_SPIKES   $e0, $a0, 21
  OBJECT_END

obj_l9:
  OBJECT_CLOWN    $10, $10
  OBJECT_SPIKES   $10, $78, 5
  OBJECT_CUBE     $10, $e0
  OBJECT_BLOB     $30, $10, 0
  OBJECT_HEART    $30, $50
  OBJECT_SPIKES   $30, $e0, 27
  OBJECT_SPIKES   $50, $30, 19
  OBJECT_BALL     $50, $78, 0
  OBJECT_SPIKES   $50, $c0, 13
  OBJECT_RABBIT   $70, $30
  OBJECT_BALL     $70, $a0, 1
  OBJECT_SPIN     $70, $c0
  OBJECT_SPIKES   $a0, $30, 9
  OBJECT_BLOB     $a0, $c0, 0
  OBJECT_BALL     $c0, $78, 0
  OBJECT_SPIKES   $c0, $c0, 10
  OBJECT_TRUMPET  $e0, $10
  OBJECT_BLOB     $e0, $78, 0
  OBJECT_TEDDY    $e0, $e0
  OBJECT_END