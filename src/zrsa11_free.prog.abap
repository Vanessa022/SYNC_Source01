*&---------------------------------------------------------------------*
*& Report ZRSA11_FREE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_FREE.

DATA: gv_char(20),                    "gv_a1 TYPE c LENGTH 20,
      gv_deci(5) TYPE p DECIMALS 2,   "소숫점은 자리 차지 X.
      gv_numc(8).                      " gv_a3 TYPE n LENGTH 8.
                                      " NUMC type 은 앞을 0으로 채우고 숫자만 넣는 타입 - numc 는 부호 없음. 연산 불가.

gv_char = 'ABCDEFGHIJ'.
gv_deci = '1.25'.
gv_numc = '00000678'.


WRITE:/ gv_char, gv_deci, gv_numc.
