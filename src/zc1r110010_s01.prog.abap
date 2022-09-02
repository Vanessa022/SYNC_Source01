*&---------------------------------------------------------------------*
*& Include          ZC1R110010_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS     : pa_car TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS : so_con FOR  sflight-connid.

SELECTION-SCREEN END OF BLOCK bl1.
