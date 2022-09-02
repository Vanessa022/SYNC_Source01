*&---------------------------------------------------------------------*
*& Report ZC1R110004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110004 MESSAGE-ID zmcsa11.

DATA: BEGIN OF gs_mara,
        matnr TYPE mara-matnr,    "Material Number.
        maktx TYPE makt-maktx,    "Material Description.
        mtart TYPE mara-mtart,    "Material Type.
        matkl TYPE mara-matkl,    "Material Group
      END OF gs_mara,
      gt_mara LIKE TABLE OF gs_mara,

      BEGIN OF gs_makt,
        matnr TYPE makt-matnr,     "Material Number.
        maktx TYPE makt-maktx,     "Material Description.
      END OF gs_makt,
      gt_makt  LIKE TABLE OF gs_makt,
      lv_tabix TYPE sy-tabix.

CLEAR : gt_mara, gt_makt, gs_mara, gs_makt.

SELECT matnr mtart matkl
  FROM mara
  INTO CORRESPONDING FIELDS OF TABLE gt_mara.

SELECT matnr maktx
  FROM makt
  INTO CORRESPONDING FIELDS OF TABLE gt_makt
  WHERE spras = sy-langu.

LOOP AT gt_mara INTO gs_mara.
  lv_tabix = sy-tabix.

  READ TABLE gt_makt INTO gs_makt
    WITH KEY matnr = gs_mara-matnr.

  IF sy-subrc = 0.
    gs_mara-maktx = gs_makt-maktx.

    MODIFY gt_mara FROM gs_mara
     INDEX lv_tabix TRANSPORTING maktx.
  ENDIF.

ENDLOOP.

cl_demo_output=>display_data( gt_mara ).
