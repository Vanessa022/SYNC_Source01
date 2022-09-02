*&---------------------------------------------------------------------*
*& Report ZRSA11_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_14.

*TYPES: BEGIN OF ts_cat,
*        home TYPE c LENGTH 10,
*        name TYPE c LENGTH 10,
*        age TYPE i,
*       END OF ts_cat.
*
**DATA: gv_cat_name TYPE c LENGTH 10,
**      gv_cat_age TYPE i.
**
*DATA gs_cat type ts_cat.
**DATA XXX TYPE ta_cat-age. "
**DATA XXX LIKE gs_cat-age. " 일반 변수 but gs_cat-age 따라감
*
**DATA: BEGIN OF gs_cat,
**        name TYPE c LENGTH 10,
**        age TYPE i,
**      END OF gs_cat.
*
*
*
*WRITE gs_cat-age.

"Transparent Table = Structure Type
DATA gs_scarr TYPE scarr. " therefore making gs_scarr the strucutre variable.

PARAMETERS pa_carr LIKE gs_scarr-carrid.

SELECT SINGLE carrid carrname currcode " *
    FROM scarr
  INTO CORRESPONDING FIELDS OF gs_scarr
*  INTO gs_scarr
  WHERE carrid = pa_carr.

  WRITE: gs_scarr-carrid, gs_scarr-carrname, gs_scarr-currcode.
