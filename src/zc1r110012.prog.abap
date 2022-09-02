*&---------------------------------------------------------------------*
*& Report ZC1R110012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r110012_top                          .    " Global Data

INCLUDE zc1r110012_s01                          .  " Selection Screen
INCLUDE zc1r110012_C01                          .  " Local Class
INCLUDE zc1r110012_o01                          .  " PBO-Modules
INCLUDE zc1r110012_i01                          .  " PAI-Modules
INCLUDE zc1r110012_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_bom_data.

 CALL SCREEN '0100'.
