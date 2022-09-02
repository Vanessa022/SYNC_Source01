*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1105
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA1106_TOP.
*INCLUDE mzsa1105_top                            .    " Global Data

INCLUDE MZSA1106_O01.
* INCLUDE mzsa1105_o01                            .  " PBO-Modules
INCLUDE MZSA1106_I01.
* INCLUDE mzsa1105_i01                            .  " PAI-Modules
INCLUDE MZSA1106_F01.
* INCLUDE mzsa1105_f01                            .  " FORM-Routines


 LOAD-OF-PROGRAM.
 PERFORM set_default CHANGING zssa0073.
 CLEAR: gv_r1, gv_r2, gv_r3.
 gv_r2 = 'X'.
