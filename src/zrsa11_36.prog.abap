*&---------------------------------------------------------------------*
*& Report ZRSA11_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_36.

TYPES: BEGIN OF ts_dep,
        budget TYPE ztsa1102-budget,
        waers  TYPE ztsa1102-waers,
       END OF ts_dep.

DATA: gs_dep TYPE zssa1120,     "ztsa1102,  "ztsa1102
      gt_dep LIKE TABLE OF gs_dep.

*PARAMETERS pa_dep LIKE gs_dep-depid.

DATA go_salv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT *
    FROM ztsa1102
    INTO CORRESPONDING FIELDS OF TABLE gt_dep.

  cl_salv_table=>factory(
    IMPORTING r_salv_table = go_salv
    CHANGING t_table = gt_dep
   ).
  go_salv->display( ).

*cl_demo_output=>display_data( gt_dep ).
