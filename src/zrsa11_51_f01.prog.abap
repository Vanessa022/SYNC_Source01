*&---------------------------------------------------------------------*
*& Include          ZRSA11_51_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_init .
  pa_car = 'AA'.
  pa_con = '0017'.

 CLEAR: so_dat[], so_dat.
  " clear 다음에는 [] internal table  structure 변수 모두 올 수 있음
  so_dat-sign = 'I'. " Include
  so_dat-option = 'BT'. "Between
  so_dat-low = sy-datum - 365.
  so_dat-high = sy-datum.
  APPEND so_dat TO so_dat[].  " []이면 internal table
*  APPEND so_dat TO so_dat.
  " 이름이 똑같으면 생략이 가능하다.
*  APPEND so_dat.
  CLEAR so_dat.
ENDFORM.
