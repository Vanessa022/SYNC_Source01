*&---------------------------------------------------------------------*
*& Report ZRCA11_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca11_01.

DATA gv_num TYPE i.
DO 6 TIMES.
  gv_num = gv_num + 1.
  WRITE sy-index.
  IF gv_num > 3.
    EXIT.
  ENDIF.
  WRITE gv_num.
  NEW-LINE.
ENDDO.

*DATA gv_gender TYPE c LENGTH 1. "M, F
*gv_gender = 'M'.
*CASE gv_gender.
*  WHEN 'M'.
*
*  WHEN 'F'.
*
*  WHEN OTHERS.
*
*ENDCASE.


*IF gv_gender = 'M'.
*
*ELSEIF gv_gender = 'F'.
*
*ELSE.
*
*ENDIF.

*gv_gender = 'F'.
