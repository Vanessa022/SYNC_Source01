*&---------------------------------------------------------------------*
*& Report ZC1R260007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R110015_SOL_TOP.                      .    " Global Data

INCLUDE ZC1R110015_SOL_S01.                      .  " Selection Screen
INCLUDE ZC1R110015_SOL_c01                       .  " Local Class
INCLUDE ZC1R110015_SOL_O01.                      .  " PBO-Modules
INCLUDE ZC1R110015_SOL_I01.                      .  " PAI-Modules
INCLUDE ZC1R110015_SOL_F01.                      .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_emp_data.
  PERFORM set_style.

  CALL SCREEN '0100'.
