*&---------------------------------------------------------------------*
*& Report ZRSA11_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_09.

DATA gv_d TYPE sy-datum.

gv_d = sy-datum - 365.

CLEAR gv_d.

IF gv_d is INITIAL.  "'00000000'.
  WRITE 'No Date'.
ELSE.
  WRITE 'Exit Date'.
ENDIF.


*DATA gv_cnt TYPE i.
*
*DO 10 TIMES.
*  gv_cnt = gv_cnt + 1.
**  WRITE sy-index.
*  DO 5 TIMES.
**    WRITE sy-index.
*  ENDDO.
**  WRITE sy-index.
**  NEW-LINE.
*ENDDO.
*
*WRITE gv_cnt.
*
*CLear gv_cnt.
*DO 5 TIMES.
*  gv_cnt = gv_cnt + 1.
*ENDDO.
