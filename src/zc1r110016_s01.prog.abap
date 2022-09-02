*&---------------------------------------------------------------------*
*& Include          ZC1R110016_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: so_car FOR scarr-carrid,
                  so_con FOR sflight-connid,
                  so_plnty  FOR sflight-planetype NO INTERVALS NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK bl1.
