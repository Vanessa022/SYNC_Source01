*&---------------------------------------------------------------------*
*& Report ZC1R110014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r110014_top                          .  " Global Data

INCLUDE ZC1R110014_s01                          .  " Selection Screen
INCLUDE ZC1R110014_c01                          .  " Local Class
INCLUDE zc1r110014_o01                          .  " PBO-Modules
INCLUDE zc1r110014_i01                          .  " PAI-Modules
INCLUDE zc1r110014_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.

START-OF-SELECTION.
  PERFORM get_belnr.

  CALL SCREEN '0100'.
