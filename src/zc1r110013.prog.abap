*&---------------------------------------------------------------------*
*& Report ZC1R110013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r110013_top                          .    " Global Data

INCLUDE ZC1R110013_s01                          .  " Selection Screen
INCLUDE ZC1R110013_c01                          .  " Local Class
INCLUDE zc1r110013_o01                          .  " PBO-Modules
INCLUDE zc1r110013_i01                          .  " PAI-Modules
INCLUDE zc1r110013_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_flight_list.

call SCREEN 100.
