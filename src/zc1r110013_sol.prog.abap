*&---------------------------------------------------------------------*
*& Report ZC1R260005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R110013_SOL_TOP.                     " Global Data

INCLUDE ZC1R110013_SOL_S01.                     " Selection Screen
INCLUDE ZC1R110013_SOL_C01.                     " Local Class
INCLUDE ZC1R110013_SOL_O01.                     " PBO-Modules
INCLUDE ZC1R110013_SOL_I01.                     " PAI-Modules
INCLUDE ZC1R110013_SOL_F01.                     " FORM-Routines


START-OF-SELECTION.
  PERFORM get_flight_list.
  PERFORM set_carrname.

  CALL SCREEN '0100'.
