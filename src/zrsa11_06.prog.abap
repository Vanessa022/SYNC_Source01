*&---------------------------------------------------------------------*
*& Report ZRSA11_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_06.

*PARAMETERS pa_i TYPE i.
*DATA gv_resutl like pa_i.

* 10보다 크면 출력, 10보다 작으면 출력X = IF문 사용.
* 20보다 크면 10을 추가로 더해라.

*IF pa_i >= 10. " + 조건.
*  WRITE pa_i.
*
*ELSEIF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE pa_i.
*ENDIF.

*PARAMETERS pa_i TYPE i.
*DATA gv_result LIKE pa_i.

* 10보다 크면 출력, 10보다 작으면 출력X = IF문 사용.
* 20보다 크면 10을 추가로 더해라.
* A번이라면, 입력한 값에 모두 100을 추가하세요.


*IF pa_i > 10.
*  WRITE pa_i.
*ENDIF.
*
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ENDIF.


*IF pa_i > 20.
*
*  ELSE.
*    IF pa_i > 10.
*
*  ENDIF.
*
*ENDIF.

PARAMETERS pa_i TYPE i.
PARAMETERS pa_class TYPE c LENGTH 1.  " A, B, C, D만 입력 가능.
DATA gv_result LIKE pa_i.

IF pa_i > 20.
  gv_result = pa_i + 10.

ELSEIF pa_i > 10.
  gv_result = pa_i.
ELSE.

ENDIF.

CASE pa_class.
  WHEN 'A'.
    gv_result = pa_i + 100.
    WRITE gv_result.
  WHEN OTHERS.

ENDCASE.

*CASE  변수.
*
*	WHEN 값.
*
*	WHEN OTHERS.
*
*ENDCASE.
