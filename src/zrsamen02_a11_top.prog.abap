*&---------------------------------------------------------------------*
*& Include ZRSAMEN02_A11_TOP                        - Report ZRSAMEN02_A11
*&---------------------------------------------------------------------*
REPORT zrsamen02_a11.

TABLES zssa19fl.

TYPES: BEGIN OF tp_sfli.
         INCLUDE TYPE sflight.
TYPES:   carrname TYPE scarr-carrname,
       END OF tp_sfli.

"ALV.
DATA: go_container_high TYPE REF TO cl_gui_custom_container,
       go_alv_grid_high TYPE REF TO cl_gui_alv_grid,

      go_container_low TYPE REF TO cl_gui_custom_container,
      go_alv_grid_low TYPE REF TO cl_gui_alv_grid.

DATA: gs_sflight      TYPE sflight,
      gt_sflight_high LIKE TABLE OF gs_sflight,
      gt_sflight_low  LIKE TABLE OF gs_sflight,
      gt_scarr TYPE TABLE of scarr,
      gs_scarr LIKE LINE OF gt_scarr.


SELECTION-SCREEN BEGIN OF BLOCK con WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS so_car FOR zssa19fl-carrid NO-EXTENSION.
  SELECT-OPTIONS so_con FOR zssa19fl-connid NO-EXTENSION.
  SELECT-OPTIONS so_fld FOR zssa19fl-fldate NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK con.
