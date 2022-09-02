*&---------------------------------------------------------------------*
*& Include ZRSA11_25_TOP                            - Report ZRSA11_25
*&---------------------------------------------------------------------*
REPORT ZRSA11_25.

* Type 선언
*TYPES: BEGIN OF ts_info,
*          carrid TYPE sflight-carrid,
*          connid TYPE sflight-connid,
*          cityfrom TYPE spfli-cityfrom,
*          cityto TYPE spfli-cityto,
*          fldate TYPE sflight-fldate,
*       END OF ts_info,
*       tt_info TYPE TABLE OF ts_info. "Table Type

* Data Object
DATA: gt_info TYPE TABLE OF ZSSA1102.
*      gs_info LIKE LINE OF gt_info.


* Selection Screen
PARAMETERS: pa_car TYPE sflight-carrid,
            pa_con1 TYPE sflight-connid,
            pa_con2 TYPE sflight-connid.
*TYPES: zssa1102 TYPE xxxxxx.
*SELECT-OPTIONS so_con for gs_info-connid. "무조건 Variable 사용해야한다
