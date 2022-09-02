*&---------------------------------------------------------------------*
*& Report ZRSA11_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_34.

" Dep Info
DATA gs_dep TYPE zssa1111.
DATA gt_dep LIKE TABLE OF gs_dep.

"Emp Info ( Structure Variable )
DATA gs_emp LIKE LINE OF gs_dep-emp_list.

PARAMETERS pa_dep TYPE ztsa1102-depid.

START-OF-SELECTION.
select SINGLE *
  FROM ztsa1102 "Dep table
  INTO CORRESPONDING FIELDS OF gs_dep
 WHERE depid = pa_dep.

  IF  sy-subrc <> 0.
    RETURN.
  ENDIF.

"Get Employee List
  SELECT *
    FROM ztsa1101 "emp table
    INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
   WHERE depid = gs_dep-depid.

    LOOP AT gs_dep-emp_list INTO gs_emp.
      "Get Gender Text

      MODIFY gs_dep-emp_list FROM gs_emp.
      CLEAR gs_emp.
    ENDLOOP.
