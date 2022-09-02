*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1102
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1102_top                            .    " Global Data

 INCLUDE mzsa1102_o01                            .  " PBO-Modules
 INCLUDE mzsa1102_i01                            .  " PAI-Modules
 INCLUDE mzsa1102_f01                            .  " FORM-Routines


 LOAD-OF-PROGRAM.
  PERFORM set_default.

*INCLUDE mzsa1102_modify_screen_0100o01.
