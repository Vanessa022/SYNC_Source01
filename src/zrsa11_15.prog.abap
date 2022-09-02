*&---------------------------------------------------------------------*
*& Report ZRSA11_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA11_15.


DATA: BEGIN OF gs_std,
        stdno  TYPE n LENGTH 8,
        sname  TYPE c LENGTH 40,
        gender TYPE c LENGTH 1,
        gender_t TYPE c LENGTH 10,    "코드성 값은 바뀌지 않음.
       END OF gs_std.
DATA gt_std LIKE TABLE OF gs_std. " gt_std 는 Internal Table. I.T 의 initial value 는 아무것도 없음.
" Like Table Of 를 쓰는 이유는 테이블 모양(row/column) 맞추기 위해서

gs_std-stdno = '20220001'.
gs_std-sname = 'PARK'.
gs_std-gender = 'M'.
APPEND gs_std TO gt_std.

CLEAR gs_std.
gs_std-stdno = '20220002'.
gs_std-sname = 'HAN'.
gs_std-gender = 'F'.
APPEND gs_std TO gt_std.
clear gs_std.

LOOP AT gt_std INTO gs_std.
  gs_std-gender_t ='Male'(t01).
  MODIFY gt_std FROM gs_std.
  CLEAR gs_std.
ENDLOOP.

*MODIFY gt_std FROM gs_std INDEX 2.

cl_demo_output=>display_data( gt_std ).

CLEAR gs_std.
*READ TABLE gt_std INDEX 1 INTO gs_std.
READ TABLE gt_std WITH KEY stdno = '20220001'	 "stdno key 딱 하나만 가져오는것. read table 의 목적은 한건만 가져오려는 것임. \
INTO gs_std.



*LOOP AT gt_std INTO gs_std..
*  WRITE: sy-tabix, gs_std-stdno,
*         gs_std-sname, gs_std-gender.
*  NEW-LINE.
*ENDLOOP.
*WRITE:/ sy-tabix, gs_std-stdno,
*        gs_std-sname, gs_std-gender.



*" INTERNAL TABLE 로 선언하는 방식 4가지:
*"1.
*DATA: gs_xxx TYPE <structure_type>,
*      gt_xxx LIKE TABLE OF gs_xxx.
*"2.
*DATA: gt_xxx TYPE <table_type>,
*      gs_xxx LIKE LINE OF gt_xxx.
*"3.
*DATA: gt_xxx TYPE TABLE OF <structure_type>, "gt_xxx 는 internal table이 된다
*      gs_xxx LIKE LINE OF gt_xxx.
*"4.
*DATA:gs_xxx TYPE LINE OF <table_type>,
*     gt_xxx LIKE TABLE OF gs_xxx.
*
*
*"안좋은 예시
*DATA: gs_xxx TYPE LINE OF <table_type>,   "위아래 <table_type> 이 같은 테이블타입
*      gt_xxx TYPE <table_type>.   "안좋은 이유는 나중에 수정할 때 위아래 두번 수정해야함.
