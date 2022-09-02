*&---------------------------------------------------------------------*
*& Include ZC1R110015_TOP                           - Report ZC1R110015
*&---------------------------------------------------------------------*
REPORT zc1r110015 MESSAGE-ID zmcsa11.

TABLES : ztsa1101.

DATA : BEGIN OF gs_emp,
         pernr  TYPE ztsa1101-pernr,
         ename  TYPE ztsa1101-ename,
         endt   TYPE ztsa1101-entdt,
         gender TYPE ztsa1101-gender,
         depid  TYPE ztsa1101-depid,
         carrid TYPE ztsa1101-carrid,
       END OF gs_emp,


       gt_emp LIKE TABLE OF gs_emp,
       gv_okcode TYPE sy-ucomm.


*ALV 관련.
DATA: gcl_container TYPE REF TO cl_gui_custom_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant,
      gs_stable     TYPE lvc_s_stbl.

PERFORM refresh_grid.
