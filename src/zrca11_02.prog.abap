*&---------------------------------------------------------------------*
*& Report ZRCA11_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca11_02.

*
*DATA gv_step TYPE i.
*DATA gv_cal LIKE gv_step.
*DATA gv_lev LIKE gv_cal.
*PARAMETERS pa_req LIKE gv_lev. "PA_REQ - 구구단 단계
*PARAMETERS pa_syear(1) TYPE c. "PA_SYEAR - 학년
*DATA gv_new_lev LIKE gv_lev. "GV_NEW_LEV - 학년에 따른 구구딘 표시
*
*CASE pa_syear.
*  WHEN '1'.
*    IF pa_req >= 3.
*       gv_new_lev = 3.
*    ELSE.
*       gv_new_lev = pa_req.
*    ENDIF.
*  WHEN '2'.
*    IF pa_req >= 5.
*       gv_new_lev = 5.
*    ELSE.
*       gv_new_lev = pa_req.
*    ENDIF.
*  WHEN '3'.
*    IF pa_req >= 7.
*       gv_new_lev = 7.
*    ELSE.
*       gv_new_lev = pa_req.
*    ENDIF.
*  WHEN '4'.
*    IF pa_req >= 9.
*       gv_new_lev = 9.
*    ELSE.
*       gv_new_lev = pa_req.
*    ENDIF.
*  WHEN '5'.
*    IF pa_req >= 9.
*       gv_new_lev = 9.
*    ELSE.
*       gv_new_lev = pa_req.
*    ENDIF.
*  WHEN '6'.
*       gv_new_lev = 9.
*  WHEN OTHERS.
*    WRITE 'Times Table not Available!'.
*
*ENDCASE.
*
*DO gv_new_lev TIMES.
*  gv_lev = gv_lev + 1.
*    DO 9 TIMES.
*  gv_step = gv_step + 1.
*  CLEAR gv_cal.
*  gv_cal = gv_lev * gv_step.
*  WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
*  NEW-LINE.
*  ENDDO.
*  CLEAR gv_step.
*  WRITE '================================================'.
*  NEW-LINE.
*ENDDO


DATA gv_step TYPE i.
DATA gv_cal LIKE gv_step.
DATA gv_lev LIKE gv_cal.
PARAMETERS pa_req LIKE gv_lev. "PA_REQ - 구구단 단계
PARAMETERS pa_syear(1) TYPE c. "PA_SYEAR - 학년
DATA gv_new_lev LIKE gv_lev. "GV_NEW_LEV - 학년에 따른 구구딘 표시

CASE pa_syear.
  WHEN '1' OR '2' OR '3' OR '4' OR '5' OR '6'.
    IF pa_req >= 3.
       gv_new_lev = 3.
    ELSE.
       gv_new_lev = pa_req.
    ENDIF.

    WHEN OTHERS.
      MESSAGE 'Message Test' TYPE 'I'. "S, E

ENDCASE.

WRITE 'Times Table'.
NEW-LINE.

DO gv_new_lev TIMES.
  gv_lev = gv_lev + 1.
    DO 9 TIMES.
  gv_step = gv_step + 1.
  CLEAR gv_cal.
  gv_cal = gv_lev * gv_step.
  WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
  NEW-LINE.
  ENDDO.
  CLEAR gv_step.
  WRITE '================================================'.
  NEW-LINE.
ENDDO.
