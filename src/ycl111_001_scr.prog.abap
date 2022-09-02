*&---------------------------------------------------------------------*
*& Include          YCL111_001_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME
                                    TITLE TEXTT01.

  SELECT-OPTIONS so_car FOR gs_scarr-carrid.
  SELECT-OPTIONS so_carnm FOR scarr-carrname.


SELECTION-SCREEN END OF BLOCK B01.
