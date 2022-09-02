*&---------------------------------------------------------------------*
*& Report ZRSA11_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_22.

TYPES: BEGIN OF gs_info,
        carrid type zsinfo-carrid,
        carrname TYPE zsinfo-carrname,
        connid TYPE zsinfo-connid,
        cityfrom TYPE zsinfo-cityfrom,
        cityto TYPE zsinfo-cityto,
       END OF gs_info.


DATA: gt_info type TABLE OF gs_info,
      gs_info LIKE LINE OF gt_info.

PARAMETERS pa_car like gs_info.

SELECT carrid carrname connid cityfrom city
  FROM zsinfo
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid = pa_car.



*DATA: gs_list TYPE scarr,
*      gt_list LIKE TABLE OF gs_list.
*
*CLEAR: gt_list,
*       gs_list.
*
**SELECT *
**  FROM scarr
**  INTO CORRESPONDING FIELDS OF gs_list
**  WHERE carrid BETWEEN 'AA' AND 'UA'.
**  APPEND gs_list TO gt_list.
**  CLEAR gs_list.
**ENDSELECT.
*
*SELECT *
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF TABLE gt_list
*  WHERE carrid BETWEEN 'AA' AND 'UA'.
*WRITE sy-subrc.
*WRITE sy-dbcnt. "SELECT 후 RECORD 건 수를 보여준다.
*
*cl_demo_output=>display_data( gt_list ).
