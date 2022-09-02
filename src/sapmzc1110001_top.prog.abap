*&---------------------------------------------------------------------*
*& Include SAPMZC1110001_TOP                        - Module Pool      SAPMZC1110001
*&---------------------------------------------------------------------*
PROGRAM SAPMZC1110001 MESSAGE-ID zmcsa11.

DATA: BEGIN OF gs_data,
        matnr TYPE ZC1TT11_0001-matnr,    "Material.
        werks TYPE ZC1TT11_0001-werks,    "Plant.
        mtart TYPE ZC1TT11_0001-mtart,    "Mat. Type.
        matkl TYPE ZC1TT11_0001-matkl,    "Mat. Group
        menge TYPE ZC1TT11_0001-menge,    "Quantity.
        meins TYPE ZC1TT11_0001-meins,    "Unit.
        dmbtr TYPE ZC1TT11_0001-dmbtr,    "Price.
        waers TYPE ZC1TT11_0001-waers,    "Currency.
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data,

      gv_okcode TYPE sy-ucomm.


* ALV 관련.
DATA: gcl_container TYPE REF TO cl_gui_custom_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.
