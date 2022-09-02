*&---------------------------------------------------------------------*
*& Include          YCL111_002_TOP
*&---------------------------------------------------------------------*

TABLES scarr.

DATA: ok_code TYPE sy-ucomm,
      save_ok TYPE sy-ucomm.

DATA: gt_scarr TYPE TABLE OF scarr.

SELECTION-SCREEN BEGIN OF SCREEN 0101 AS SUBSCREEN.
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(10) TEXT-L02 FOR FIELD so_car.   "항공사 ID
    SELECT-OPTIONS: so_car  FOR scarr-carrid.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(10) TEXT-L03 FOR FIELD so_carnm.   "항공사명
    SELECT-OPTIONS: so_carnm  FOR scarr-carrname.
    SELECTION-SCREEN PUSHBUTTON 77(10) TEXT-L01 USER-COMMAND SEARCH.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN END OF BLOCK b01.
SELECTION-SCREEN END OF SCREEN 0101.
