*&---------------------------------------------------------------------*
*& Include ZC1R260007_TOP                           - Report ZC1R260007
*&---------------------------------------------------------------------*
REPORT zc1r110015_sol MESSAGE-ID zmcsa11.

TABLES : ztsa1101.

DATA : BEGIN OF gs_emp,
         mark,
         pernr  TYPE ztsa1101-pernr,
         ename  TYPE ztsa1101-ename,
         entdt  TYPE ztsa1101-entdt,
         gender TYPE ztsa1101-gender,
         depid  TYPE ztsa1101-depid,
         carrid TYPE ztsa1101-carrid,
         style  TYPE lvc_t_styl,
       END OF gs_emp,

       gt_emp     LIKE TABLE OF gs_emp,
       gt_emp_del LIKE TABLE OF gs_emp.

DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

DATA: gt_rows TYPE lvc_t_row,   "사용자가 선택한 행의 정보를 삭제.
      gs_row  TYPE lvc_s_row.

DATA : gv_okcode TYPE sy-ucomm.
