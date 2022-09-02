*&---------------------------------------------------------------------*
*& Report ZC1R110010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R110010_TOP                          .    " Global Data

 INCLUDE ZC1R110010_s01                          .  " Selection Screen
 INCLUDE ZC1R110010_O01                          .  " PBO-Modules
 INCLUDE ZC1R110010_I01                          .  " PAI-Modules
 INCLUDE ZC1R110010_F01                          .  " FORM-Routines

 INITIALIZATION.
  PERFORM init_param.


START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN '0100'.
