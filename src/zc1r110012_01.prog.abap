*&---------------------------------------------------------------------*
*& Report ZC1R110012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R110012_01_TOP.                       " Global Data

INCLUDE ZC1R110012_01_S01.                       " Selection Screen
INCLUDE ZC1R110012_01_C01.                       " Local Class
INCLUDE ZC1R110012_01_O01.                       " PBO-Modules
INCLUDE ZC1R110012_01_I01.                       " PAI-Modules
INCLUDE ZC1R110012_01_F01.                       " FORM-Routines

START-OF-SELECTION.
  PERFORM get_bom_data.

 CALL SCREEN '0100'.
