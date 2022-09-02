*&---------------------------------------------------------------------*
*& Report ZC1R110016
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r110016_top                          .   " Global Data

 INCLUDE ZC1R110016_s01                          .  " Selection Screen
 INCLUDE ZC1R110016_c01                          .  " Local Class
 INCLUDE zc1r110016_o01                          .  " PBO-Modules
 INCLUDE zc1r110016_i01                          .  " PAI-Modules
 INCLUDE zc1r110016_f01                          .  " FORM-Routines

 START-OF-SELECTION.

 PERFORM get_data.

 CALL SCREEN '0100'.
