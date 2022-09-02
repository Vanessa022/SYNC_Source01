*&---------------------------------------------------------------------*
*& Report ZRSA11_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_32.

DATA gs_emp TYPE  ZSSA1110.

PARAMETERS pa_pernr LIKE gs_emp-pernr.

INITIALIZATION.
  pa_pernr = '20220001'.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa1101 "Employee Table
    INTO CORRESPONDING FIELDS OF gs_emp
    WHERE pernr = pa_pernr.
    IF sy-subrc <> 0.
      MESSAGE i001(zmcsa11).
      "Message is not found.
      RETURN.
    ENDIF.

*    WRITE gs_emp-depid.
*    NEW-LINE.
*    WRITE gs_emp-dep-depid.
SELECT SINGLE *
  FROM ztsa1102
  INTO gs_emp-dep
  WHERE depid = gs_emp-depid.



    cl_demo_output=>display_data( gs_emp-dep ).
