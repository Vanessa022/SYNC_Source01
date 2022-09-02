*&---------------------------------------------------------------------*
*& Include ZC1R110012_TOP                           - Report ZC1R110012
*&---------------------------------------------------------------------*
REPORT ZC1R110012 MESSAGE-ID zmcsa11.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES : mast.

DATA : BEGIN OF gs_mast,
         matnr TYPE mast-matnr,
         maktx TYPE makt-maktx,
         stlan TYPE mast-stlan,
         stlnr TYPE mast-stlnr,
         stlal TYPE mast-stlal,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF gs_mast,

       gt_mast LIKE TABLE OF gs_mast.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler    TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : gv_okcode TYPE sy-ucomm.

DEFINE _clear.

  CLEAR   &1.
  REFRESH &1.

END-OF-DEFINITION.
