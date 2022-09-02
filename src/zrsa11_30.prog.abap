*&---------------------------------------------------------------------*
*& Report ZRSA11_30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_30.


TYPES: BEGIN OF ts_info,
         stdno TYPE n LENGTH 8,
         sname TYPE c LENGTH 40,
       END OF ts_info.

 DATA gs_std TYPE ZSSA1101. "gs_std는 structure 변수가 된다

gs_std-stdno = '20220001'.
gs_std-sname = 'Park ET'.
