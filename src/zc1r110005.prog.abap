*&---------------------------------------------------------------------*
*& Report ZC1R110005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110005 MESSAGE-ID zmcsa11.

DATA: BEGIN OF gs_spfli,
        carrid   TYPE spfli-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
        connid   TYPE spfli-connid,
        airpfrom TYPE spfli-airpfrom,
        airpto   TYPE spfli-airpto,
        deptime  TYPE spfli-deptime,
        arrtime  TYPE spfli-arrtime,
      END OF gs_spfli,

      gt_spfli LIKE TABLE OF gs_spfli,

      BEGIN OF gs_scarr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF gs_scarr,

      gt_scarr LIKE TABLE OF gs_scarr,
      lv_tabix TYPE sy-tabix.


CLEAR: gs_spfli, gt_spfli, gs_scarr, gt_scarr.

SELECT carrid connid airpfrom
       airpto deptime arrtime
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_spfli.

SELECT carrid carrname url
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE gt_scarr.

CLEAR: lv_tabix.

LOOP AT gt_spfli INTO gs_spfli.
  lv_tabix = sy-tabix.

  READ TABLE gt_scarr INTO gs_scarr
    WITH KEY carrid = gs_spfli-carrid.

  IF sy-subrc = 0.
    gs_spfli-carrname = gs_scarr-carrname.
    gs_spfli-url      = gs_scarr-url.

    MODIFY gt_spfli FROM gs_spfli
     INDEX lv_tabix TRANSPORTING carrname url.
  ENDIF.

ENDLOOP.

cl_demo_output=>display_data( gt_spfli ).
