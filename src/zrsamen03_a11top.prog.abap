*&---------------------------------------------------------------------*
*& Include ZRSAMAR02TOP                             - Report ZRSAMAR02_A19
*&---------------------------------------------------------------------*
REPORT zrsamar02_a19.

TABLES: zssa19fl.

DATA: ok_code  TYPE sy-ucomm.

TYPES: BEGIN OF tp_sfli.
         INCLUDE TYPE sflight.
TYPES:   carrname TYPE scarr-carrname,
       END OF tp_sfli.

"ALV DATA
DATA: go_container_high TYPE REF TO cl_gui_custom_container,
      go_alv_grid_high  TYPE REF TO cl_gui_alv_grid,
      gt_fcat_high      TYPE lvc_t_fcat,
      gs_layout_high    TYPE lvc_s_layo,


      go_container_low  TYPE REF TO cl_gui_custom_container,
      go_alv_grid_low   TYPE REF TO cl_gui_alv_grid,
      gt_fcat_low       TYPE lvc_t_fcat,
      gs_layout_low     TYPE lvc_s_layo,
      gt_exct_low       TYPE ui_functions,

      gs_fcat           TYPE lvc_s_fcat.




DATA: gs_sflight      TYPE tp_sfli,
      gt_sflight_high LIKE TABLE OF gs_sflight,
      gt_sflight_low  LIKE TABLE OF gs_sflight,
      gs_scarr        TYPE scarr,
      gt_scarr        LIKE TABLE OF gs_scarr.

DATA : gs_stable       TYPE          lvc_s_stbl,
       gv_soft_refresh TYPE          abap_bool.


SELECTION-SCREEN BEGIN OF BLOCK con WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR zssa19fl-carrid NO-EXTENSION,
                so_con FOR zssa19fl-connid NO-EXTENSION,
                so_fld FOR zssa19fl-fldate NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK con.
