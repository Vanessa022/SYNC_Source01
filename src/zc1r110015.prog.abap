*&---------------------------------------------------------------------*
*& Report ZC1R110015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r110015_top                          .    " Global Data

INCLUDE ZC1R110015_s01                          .  " Selection Screen
INCLUDE ZC1R110015_c01                          .  " Local Class
INCLUDE zc1r110015_o01                          .  " PBO-Modules
INCLUDE zc1r110015_i01                          .  " PAI-Modules
INCLUDE zc1r110015_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_emp_data.


CALL SELECTION-SCREEN '0100'.
