*&---------------------------------------------------------------------*
*& Include          YCL111_001_CLS
*&---------------------------------------------------------------------*
"ALV
" 1. List
"   -> WRITE (현재 사용 X)
" 2. Functional ALV
"   -> reuse
" 3. Class ALV
"   -> Simple ALV (편집불가 - 데이터 띄워놓고 수정이 불가능하다)
"   -> Grid ALV (실무에서 대다수 사용)
"   -> ALV with IDA (최신 방법)


*Container
*1. Custom Container -> 직접 그려서 사용
*2. Docking Container -> 언제든 어떤 이벤트에 화면 추가 생성 가능
*3. Splitter Container -> 화면을(Container) 쪼개준다

DATA: gr_con     TYPE REF TO cl_gui_docking_container,
      gr_split   TYPE REF TO cl_gui_splitter_container,
      gr_con_top TYPE REF TO cl_gui_container,
      gr_con_alv TYPE REF TO cl_gui_container.

DATA: gr_alv     TYPE REF TO cl_gui_alv_grid,
      gs_layout  TYPE lvc_s_layo,
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat,

      gs_variant TYPE disvariant,
      gs_save    TYPE c.
