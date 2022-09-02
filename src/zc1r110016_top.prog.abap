*&---------------------------------------------------------------------*
*& Include ZC1R110016_TOP                           - Report ZC1R110016
*&---------------------------------------------------------------------*
REPORT zc1r110016 MESSAGE-ID zmcsa11.

TABLES: scarr, sflight.

"DATA.
DATA: BEGIN OF gs_data,
        carrid    TYPE scarr-carrid,
        carrname  TYPE scarr-carrname,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        planetype TYPE sflight-planetype,
        price     TYPE sflight-price,
        currency  TYPE sflight-currency,
        url       TYPE scarr-url,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

DATA: BEGIN OF gs_saplane,
        planetype TYPE saplane-planetype,
        tankcap   TYPE saplane-tankcap,
        cap_unit  TYPE saplane-cap_unit,
      END OF gs_saplane,

      gt_saplane LIKE TABLE OF gs_saplane.

*ALV 관련.
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.

DATA: gv_okcode TYPE sy-ucomm.
