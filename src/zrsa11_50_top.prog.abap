*&---------------------------------------------------------------------*
*& Include ZRSA11_50_TOP                            - Report ZRSA11_50
*&---------------------------------------------------------------------*
REPORT ZRSA11_50.


DATA: gs_info TYPE ZVSA11PRO, "Database View
      gt_info LIKE TABLE OF gs_info.

PARAMETERS pa_pernr LIKE gs_info-pernr.

START-OF-SELECTION.
SELECT *
    FROM ZTSA11PRO INNER JOIN ztsa1101
      ON ZTSA11PRO~pernr = ztsa1101~pernr
    INTO CORRESPONDING FIELDS OF TABLE gt_info
   WHERE ZTSA11PRO~pernr = pa_pernr.

*SELECT *
*  FROM ztsa11PRO AS prdt LEFT OUTER JOIN ztsa1101 AS emp
*  on prdt~pernr = emp~pernr
*  INTO CORRESPONDING FIELDS OF TABLE gt_info.

  cl_demo_output=>display_data( gt_info ).
