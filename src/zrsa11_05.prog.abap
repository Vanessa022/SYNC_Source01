*&---------------------------------------------------------------------*
*& Report ZRSA11_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_05.

WRITE 'Last Name'(t01).
WRITE 'First Name'(t02).

*WRITE TEXT-t01. "Last Name
*WRITE TEXT-t01. "Last Name


**DATA gv_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*CONSTANTS gc_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*
*WRITE gv_ecode.
*
*gv_ecode = 'TEST'.


*TYPES t_name TYPE c LENGTH 10.
*
*DATA gv_name TYPE t_name.
*DATA gv_cname TYPE t_name.

" 위의 LOCAL TYPE 과 똑같은 결과물을 내는 GLOBAL TYPE.
*DATA: gv_name TYPE c LENGTH 20,
*      gv_cname LIKE gv_name.



*DATA gv_p TYPE p LENGTH 2 DECIMALS 2.
*
*gv_p = '1.23'.
*WRITE gv_p.

*DATA: gv_n1 TYPE n,
*      gv_n2 TYPE n LENGTH 2,
*      gv_i TYPE i.

*WRITE: gv_n1, gv_n2, gv_i.

*DATA: gv_c1 TYPE c LENGTH 1,
*      gv_c2(1) TYPE c,
*      gv_c3 TYPE c,
*      gv_c4.

*DATA gv_d1 TYPE d.
*DATA gv_d2 TYPE sy-datum.
*
*WRITE: gv_d1, gv_d2.
