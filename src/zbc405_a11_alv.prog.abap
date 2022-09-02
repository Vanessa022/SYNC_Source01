*&---------------------------------------------------------------------*
*& Report ZBC405_A11_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a11_alv.

TYPES: BEGIN OF typ_flt.
         INCLUDE TYPE sflight.  " 단독으로 선언.
TYPES:   changes_possible TYPE icon-id.
TYPES: btn_text TYPE c LENGTH 10.

TYPES: tankcap  TYPE saplane-tankcap,
       cap_unit TYPE saplane-cap_unit,
       weight   TYPE saplane-weight,
       wei_unit TYPE saplane-wei_unit.

TYPES:   light TYPE c LENGTH 1.
TYPES: row_color  TYPE c LENGTH 4.  "특정 값을 가지게 되는 순간  row는 색이 들어간다.
TYPES: it_color   TYPE lvc_t_scol.  " Cell 단위 컬러 담당. "테이블 타입
TYPES: it_styl    TYPE lvc_t_styl.  " Cell Style 정의 담당 "Table 타입.
TYPES: END OF typ_flt.

DATA: gt_flt TYPE TABLE OF typ_flt. "데이터를 넣을 Table
DATA: gs_flt TYPE typ_flt.          "중간의 Work Area
DATA: ok_code LIKE sy-ucomm.

*-- ALV DATA 선언 --*
" TABLE 형태의 타입을 넣기 위한 work area 선언
" TABLE 형태는 본인 스스로 APPEND를 못하기 때문(스스로 데이터 처리 X - 빈통만 있는 격).
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      gv_variant   TYPE disvariant,   "variant 설정용
      gv_save      TYPE c LENGTH 1,
      gs_layout    TYPE lvc_s_layo,
      gt_sort      TYPE lvc_t_sort,
      gs_sort      TYPE lvc_s_sort,
      gs_color     TYPE lvc_s_scol,
      gt_exct      TYPE ui_functions,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_styl      TYPE lvc_s_styl.

DATA: gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.   "Global Constant X or Space


INCLUDE ZBC405_A11_ALV_class.


*-- Selection Screen --*

SELECT-OPTIONS: so_car FOR gs_flt-carrid MEMORY ID car,
                so_con FOR gs_flt-connid MODIF ID car,
                so_dat FOR gs_flt-fldate.

SELECTION-SCREEN SKIP 1.

PARAMETERS: p_date TYPE sy-datum DEFAULT '20201001'.    "기준 날짜.

PARAMETERS: pa_lv TYPE disvariant-variant.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv. "pa_lv에 F4 기능 추가하는 것.

  gv_variant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F'    "S(save), F(F4), L(load)
    CHANGING
      cs_variant      = gv_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here

  ELSE.
    pa_lv = gv_variant-variant.
  ENDIF.


START-OF-SELECTION.


  PERFORM get_data.

  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  DATA: utab TYPE ui_functions.

*  APPEND 'SAVE' TO utab.
*  APPEND 'DELE' TO utab.

  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T10' WITH sy-datum sy-uname.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.

      " memory 확보를 위한 것. 안해도 문제가 없지만 해주는 것을 원칙으로 한다.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.

      FREE: go_alv_grid, go_container.
      "내가 만든 object가 release 되고 새로운 것이 된다.

      LEAVE TO SCREEN 0.  " Set Screen 0. Leave Scren.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.

*-- Container 얹기 --*
  IF  go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.




*-- Container 위에 ALV 얹기 --*
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container  " 어디에 얹혀질것인가를 묻는 것 = go_container 위!
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    PERFORM make_variant.
    PERFORM make_layout.
    PERFORM make_sort.
    PERFORM make_fieldcatalog.

    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
    APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exct.

*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct.  "TOOLBAR 전부 사라짐.


*-- ALV에 속한 method --*
    SET HANDLER lcl_handler=>on_doubleclick          FOR go_alv_grid. "Event Trigger.
    SET HANDLER lcl_handler=>on_hotspot              FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar              FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command         FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click         FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_before_user_com      FOR go_alv_grid.

    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SFLIGHT'
        is_variant                    = gv_variant
        i_save                        = gv_save
        i_default                     = 'X'    "X, A, U.
        is_layout                     = gs_layout
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exct
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flt "보여지는 테이블은 gt_flt다.
        it_fieldcatalog               = gt_fcat
        it_sort                       = gt_sort "순서.
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.

  ELSE.

*     ON CHANGE OF gt_flt.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*       Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


*-- Subroutine --*
FORM get_data .

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
   WHERE carrid IN so_car
     AND connid IN so_con
     AND fldate IN so_dat.


  LOOP AT gt_flt INTO gs_flt.

    IF gs_flt-seatsocc < 5.
      gs_flt-light = 1. "red

    ELSEIF gs_flt-seatsocc < 100.
      gs_flt-light = 2. "yellow

    ELSE.
      gs_flt-light = 3. "green

    ENDIF.

    IF gs_flt-fldate+4(2) = sy-datum+4(2).  "데이터가 현재 월(month) 와 같은 데이터면 row 컬러 변경.
      gs_flt-row_color = 'C511'.
    ENDIF.

    IF gs_flt-planetype = '747-400'.
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.     " Total - Yellow.
      gs_color-color-int = '1'.           " Intensified - 색 강조 ON(1) & OFF(0)
      gs_color-color-inv = '0'.           " Inversed - 배경색 강조 ON(1) & OFF(0)
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    IF gs_flt-seatsocc_b = '0'.
      gs_color-fname = 'SEATSOCC_B'.
      gs_color-color-col = col_negative. " Negative - Red.
      gs_color-color-int = '1'.          " Intensified - 색 강조 ON(1) & OFF(0)
      gs_color-color-inv = '0'.          " Inversed - 배경색 강조 ON(1) & OFF(0)
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.


    IF gs_flt-fldate < p_date.
      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.
    ENDIF.


    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-btn_text = 'FULLSEATS!'.


      gs_styl-fieldname = 'BTN_TEXT'.
      gs_styl-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-it_styl.

    ENDIF.


    SELECT SINGLE tankcap cap_unit weight wei_unit
      INTO (gs_flt-tankcap, gs_flt-cap_unit,
            gs_flt-weight, gs_flt-wei_unit)
      FROM saplane
      WHERE planetype = gs_flt-planetype.

    MODIFY gt_flt FROM gs_flt.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .

  gv_variant-report = sy-cprog.
  gv_variant-variant = pa_lv.       "F4를 누르지 않고 직접 입력해도 F4를 탈 수 있도록 입력해준것.
  gv_save = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .

  gs_layout-zebra = 'X'.            "zebra 무늬 옵션 설정 O.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'D'.        " A (Multiple Columns/records(row)/ no selection column)
  " B (Multiple column / single row / selection column)
  " C (A랑 동일 + select 버튼 X)
  " D (cell 선택 가능 / 모든 옵션 가능)
  " space

  gs_layout-excp_fname = 'LIGHT'.   "Exception Handling 설정  "3구 신호등
  gs_layout-excp_led = 'X'.         " 신호등 모양 변경 - 1구 신호등 옵션 - led light


  gs_layout-info_fname = 'ROW_COLOR'.   "line에 대해 ROW 컬러를 담당하는 필드는 ROW_COLOR 이다.

  gs_layout-ctab_fname = 'IT_COLOR'.    "Cell의 컬러 담당하는 필드는 it_color 이다.

  gs_layout-stylefname = 'IT_STYL'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .

  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.   " Up - Ascending
  gs_sort-spos = 1.   "sort 순서.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-down = 'X'. " Down - Descending
  gs_sort-spos = 2.   "sort 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-up = 'X'.   " Up - Ascending
  gs_sort-spos = 3.   "sort 순서
  APPEND gs_sort TO gt_sort.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .

  CLEAR : gs_fcat.
  gs_fcat-fieldname  = 'CARRID'.
*  gs_fcat-hotspot   = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname  = 'LIGHT'.
  gs_fcat-coltext    = 'INFO'.       "coltext = column text = 컬럼 이름 바꿈
  gs_fcat-just       = 'C'.           "중앙정렬.
  APPEND gs_fcat TO gt_fcat.

*  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-no_out    = 'X'.          "화면에서 사라진다.
*  APPEND gs_fcat TO gt_fcat.

*  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-hotspot   = 'X'.         "더블클릭시 실행이 아니라 셀에 포인터를 대면 손모양으로 바뀌고 밑줄쳐진다@
*  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname  = 'PRICE'.
  gs_fcat-emphasize  = 'C610'.     "컬러로 강조
  gs_fcat-col_opt    = 'X'.
*  gs_fcat-edit      = 'X'.
  APPEND gs_fcat TO gt_fcat.

*  CLEAR: gs_fcat.
*  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-emphasize = 'C610'.     "컬러로 강조
*  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname  = 'CHANGES_POSSIBLE'.
  gs_fcat-coltext    = 'Chang.Poss'.
  gs_fcat-col_pos    = 5.
  gs_fcat-col_opt    = 'X'.
*  gs_fcat-icon      = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname  = 'PAYMENTSUM'.
  gs_fcat-col_opt    = 'X'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR: gs_fcat.
  gs_fcat-fieldname  = 'BTN_TEXT'.
  gs_fcat-coltext    = 'Status'.
  gs_fcat-col_pos     = 12.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname  = 'TANKCAP'.
  gs_fcat-ref_table  = 'SAPLANE'.
  gs_fcat-ref_field  = 'TANKCAP'.
  gs_fcat-col_pos    = 20.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CAP_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'CAP_UNIT'.
  gs_fcat-col_pos = 21.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WEIGHT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEIGHT'.
*  gs_fcat-decimals  = 0.
  gs_fcat-col_pos = 22.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEI_UNIT'.
  gs_fcat-col_pos = 23.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
