*&---------------------------------------------------------------------*
*& Report ZRSA11_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_33.

DATA gs_dep TYPE zssa1106. "deep info
"Emp Info
DATA:   gt_emp TYPE TABLE OF zssa1105,  "Emp Info
        gs_emp LIKE LINE OF gt_emp.

PARAMETERS pa_dep TYPE ztsa1102-depid.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa1102 " dep table
    INTO CORRESPONDING FIELDS OF gs_dep
   WHERE depid = pa_dep.

  cl_demo_output=>display_data( gs_dep ).

  SELECT *
    FROM ztsa1101
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE depid = gs_dep-depid.
  cl_demo_output=>display_data( gt_emp ).
