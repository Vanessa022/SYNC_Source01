*&---------------------------------------------------------------------*
*& Include MZSA1150_TOP                             - Module Pool      SAPMZSA1150
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1150.

"Button
DATA ok_code TYPE sy-ucomm.

"Condition
TABLES ZSSA11VEN_01.
*DATA gs_cond TYPE zssa11ven_01.

"Inflight Meal Info
TABLES zssa11ven_02.
*DATA gs_inf TYPE zssa11ven_02.

"Vendor
TABLES zssa11ven_03.
*DATA gs_vend TYPE zssa11ven_03.

"Tab Strip
CONTROLS ts_info TYPE TABSTRIP.
