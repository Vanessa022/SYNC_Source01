*&---------------------------------------------------------------------*
*& Include MZSA1110_TOP                             - Module Pool      SAPMZSA1110
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA1110.

"Common Variable
DATA ok_code TYPE sy-ucomm.
DATA gv_subrc TYPE sy-subrc. "0 / 0 <>


"Condition
TABLES zssa1180. "Use Screen

"Use ABAP
*Data gs_cond TYPE zssa1180.

"Airline Info
TABLES zssa1181.
*DATA gs_ariline TYPE zssa1181.

"Connection Info
TABLES zssa1182.
*DATA gs_conn TYPE zssa1182.
