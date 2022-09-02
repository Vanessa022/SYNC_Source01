*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1105
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1105_top                            .    " Global Data

 INCLUDE mzsa1105_o01                            .  " PBO-Modules
 INCLUDE mzsa1105_i01                            .  " PAI-Modules
 INCLUDE mzsa1105_f01                            .  " FORM-Routines


 LOAD-OF-PROGRAM.
 PERFORM set_default CHANGING zssa0073.
