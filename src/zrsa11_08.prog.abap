*&---------------------------------------------------------------------*
*& Report ZRSA11_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_08.

PARAMETERS pa_code TYPE c LENGTH 4 DEFAULT 'SYNC'. "default 선언하면 SYNC 자동으로 입력됨.
PARAMETERS pa_date TYPE sy-datum. " defined type.
DATA gv_cond_d1 LIKE pa_date.
DATA gv_cond_d2 LIKE pa_date.
DATA gv_cond_d3 LIKE pa_date.

gv_cond_d1 = sy-datum + 7. "일주일 후
gv_cond_d2 = sy-datum - 7. "일주일 전
gv_cond_d3 = sy-datum + 365. "1년 후

WRITE pa_date.

CASE pa_code.
  WHEN 'SYNC'.

  WHEN OTHERS.
    WRITE '다음 기회에'(t03).
    EXIT. "또는 Return 사용.

ENDCASE.

IF pa_date = gv_cond_d1.
  WRITE 'ABAP Dictionary'(t02).
 ELSEIF pa_date = gv_cond_d2.
   WRITE 'SAPUI5'(t04).
 ELSEIF pa_date = gv_cond_d3.
   WRITE '취업'(t05).
 ELSEIF pa_date <= '20220620'.
   WRITE '교육준비중'(t06).
ELSE.
WRITE 'ABAP Workbench'(t01).
ENDIF.
