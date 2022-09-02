*&---------------------------------------------------------------------*
*& Report ZRSA11_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_37.

DATA: gs_info TYPE zvsa1102, "Database View
      gt_info LIKE TABLE OF gs_info.

PARAMETERS pa_dep LIKE gs_info-depid.

START-OF-SELECTION.
*SELECT *
*  FROM zvsa1102 "Database View
*  INTO CORRESPONDING FIELDS OF TABLE gt_info.
**  WHERE depid = pa_dep.

  " Open SQL
*  SELECT *
*    FROM ztsa1101 INNER JOIN ztsa1102
*      ON ztsa1101~depid = ztsa1102~depid
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*   WHERE ztsa1101~depid = pa_dep.

*SELECT a~pernr a~ename a~depid b~phone
*  FROM ztsa1101 as a INNER JOIN ztsa1102 as b
*  on a~depid = b~depid
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE a~depid = pa_dep.

SELECT *
  FROM ztsa1101 AS emp LEFT OUTER JOIN ztsa1102 AS dep
  on emp~depid = dep~depid
  INTO CORRESPONDING FIELDS OF TABLE gt_info.

  cl_demo_output=>display_data( gt_info ).
