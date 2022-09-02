*&---------------------------------------------------------------------*
*& Report ZRCA11_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca11_04.

PARAMETERS pa_car TYPE scarr-carrid. "char 3
*PARAMETERS pa_car1 TYPE c LENGTH 3.

DATA gs_info TYPE scarr.

clear gs_info.
SELECT SINGLE carrid carrname
  FROM scarr
  INTO gs_info
  WHERE carrid = pa_car.

WRITE: gs_info-mandt, gs_info-carrid, gs_info-carrname.
