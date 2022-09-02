*&---------------------------------------------------------------------*
*& Include MZSA1102_TOP                             - Module Pool      SAPMZSA1102
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1102.

*DATA: BEGIN OF gs_cond,
*        carrid TYPE sflight-carrid,
*        connid TYPE sflight-connid,
*      END OF gs_cond.
" Local 형태


" Condition
TABLES zssa1160.
" Global 형태

DATA ok_code LIKE sy-ucomm.
