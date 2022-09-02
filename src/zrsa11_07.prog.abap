*&---------------------------------------------------------------------*
*& Report ZRSA11_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_07.

PARAMETERS pa_date TYPE sy-datum.
DATA gv_today TYPE sy-datlo.
DATA gv_result LIKE pa_date.


NEW-LINE.
*IF pa_date > sy-datum + 7.
  WRITE 'ABAP Workbench'.

*ELSEIF = pa_date + .
*  WRITE 'ABAP Dictionary'.

*ENDIF.

*
**
**gv_result = pa_date + 2.
**  WRITE gv_result.
