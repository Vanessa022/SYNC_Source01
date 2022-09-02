*&---------------------------------------------------------------------*
*& Report ZBC405_A11_EXAM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a11_exam01.

TABLES: ztspfli_a11.


*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR ztspfli_a11-carrid MEMORY ID car,
                  so_con FOR ztspfli_a11-connid MEMORY ID con.

  SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK  b1.

SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN COMMENT 1(14) TEXT-002.                "Choose Layout.
    SELECTION-SCREEN POSITION POS_LOW.
    PARAMETERS p_layout TYPE disvariant-variant.

    SELECTION-SCREEN COMMENT pos_high(10) FOR FIELD p_edit. "Edit Mode.
    PARAMETERS p_edit AS CHECKBOX.

  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK  b2.



SELECTION-SCREEN SKIP.




*----------------------------------------------------------------------*

TYPES: BEGIN OF gty_spfli.
         INCLUDE TYPE ztspfli_a11.

TYPES:   btn_text TYPE c LENGTH 10.

TYPES: light       TYPE c LENGTH 1,
       color       TYPE lvc_t_scol,
       row_color   TYPE c LENGTH 4,
       fltdi       TYPE c LENGTH 1,           "I&D FC
       fltype_icon TYPE icon-id,
       bt          TYPE lvc_t_styl,
       f_tzone     TYPE sairport-time_zone,
       t_tzone     TYPE sairport-time_zone,
       modified    TYPE c LENGTH 1.
TYPES: END OF gty_spfli.


DATA: gt_spfli TYPE TABLE OF gty_spfli,
      gs_spfli TYPE          gty_spfli.

DATA: gs_airport TYPE sairport,
      gt_airport LIKE TABLE OF gs_airport.

DATA: ok_code TYPE sy-ucomm.




*-- FOR ALV 변수 --*

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gt_exct    TYPE ui_functions,
      gs_layout  TYPE lvc_s_layo,
      gs_color   TYPE lvc_s_scol,
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat.




INCLUDE ZBC405_A11_EXAM01_class.


*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.      "Search Help.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'               "S :save, L :load  F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.

  ELSE.
    p_layout    = gs_variant-variant.
  ENDIF.


INITIALIZATION.
  gs_variant-report = sy-cprog.


START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.






*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CLEAR: ok_code.

  IF p_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.

  SET TITLEBAR 'T100' WITH sy-datum sy-uname.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
 DATA : g_result .


  CASE ok_code.
    WHEN 'SAVE'.

      PERFORM ask_save USING TEXT-005 TEXT-006
                CHANGING g_result.
      IF g_result = '1'.
        PERFORM data_save.
      ENDIF.

  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: gt_temp TYPE TABLE OF gty_spfli.


  SELECT *
    FROM ztspfli_a11
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli
    WHERE carrid IN so_car
      AND connid IN so_con.

  SELECT *
    FROM sairport
    INTO CORRESPONDING FIELDS OF TABLE gt_airport.


  LOOP AT gt_spfli INTO gs_spfli.

    " I&D FC 설정.
    CLEAR : gs_color.
    IF gs_spfli-countryfr = gs_spfli-countryto.
      gs_spfli-fltdi = 'D'.
      gs_color-fname = 'FLTDI'.
      gs_color-color-col = col_positive.
      gs_color-color-int = 1.
      gs_color-color-inv = 0.
      APPEND gs_color TO gs_spfli-color.

    ELSE.
      gs_spfli-fltdi = 'I'.
      gs_color-fname = 'FLTDI'.
      gs_color-color-col = col_total.
      gs_color-color-int = 1.
      gs_color-color-inv = 0.
      APPEND gs_color TO gs_spfli-color.

    ENDIF.


    " Exception Handling 설정.
    IF gs_spfli-period = 0.
      gs_spfli-light = 3.           " GREEN
    ELSEIF gs_spfli-period = 1.
      gs_spfli-light = 2.           " YELLOW.
    ELSEIF gs_spfli-period =< 2.
      gs_spfli-light = 1.           " RED
    ENDIF.


    " FLTYPE ICON 설정.
    CASE gs_spfli-fltype.
      WHEN 'X'.
        gs_spfli-fltype_icon = icon_ws_plane.
      WHEN OTHERS.
        gs_spfli-fltype_icon = icon_space.
    ENDCASE.

    " Arrival & Dept Time Calculation
    CLEAR gs_airport.
    READ TABLE gt_airport INTO gs_airport WITH KEY id = gs_spfli-airpfrom.
    gs_spfli-f_tzone = gs_airport-time_zone.
    CLEAR gs_airport.
    READ TABLE gt_airport INTO gs_airport WITH KEY id = gs_spfli-airpto.
    gs_spfli-t_tzone = gs_airport-time_zone.


    MODIFY gt_spfli FROM gs_spfli.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.


*-- Container --*
  IF  go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.
    IF sy-subrc = 0.


*-- ALV --*
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.
      IF sy-subrc = 0.


        PERFORM set_variant.
        PERFORM set_layout.
        PERFORM make_field_catalog.

        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exct.

        APPEND cl_gui_alv_grid=>mc_fc_check TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_mb_paste TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
*        APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.

       CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_enter.
       "값이 즉시 변경되게 하려면 register_edit_event 항상 불러주어야 한다.



        SET HANDLER lcl_handler=>on_toolbar             FOR go_alv.
        SET HANDLER lcl_handler=>on_usercommand         FOR go_alv.
        SET HANDLER lcl_handler=>on_doubleclick         FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed        FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finish FOR go_alv.


*-- ALV 속한 Method --*
        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSPFLI_A11'
            is_variant           = gs_variant
            i_save               = 'A'
            i_default            = 'X'
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_spfli
            it_fieldcatalog      = gt_fcat
*           it_sort              =
*           it_filter            =
*            EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*           Implement suitable error handling here
        ENDIF.
      ENDIF.
    ENDIF.

  ELSE.

   DATA:
      gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.

*  -- refresh alv method 올 자리. --*

    gV_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh.
*      EXCEPTIONS
*        finished       = 1
*        OTHERS         = 2.
    IF sy-subrc <> 0.
*       Implement suitable error handling here
    ENDIF.
*       CALL METHOD cl_gui_cfw=>flush.







  ENDIF.

ENDMODULE.


*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  gs_variant-variant = p_layout.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .

  gs_layout-cwidth_opt = 'X'.              " Coloumn Width Optimztion.
  gs_layout-zebra = 'X'.                   " zebra 무늬 .
  gs_layout-sel_mode = 'D'.


  gs_layout-excp_fname = 'LIGHT'.          " Exception Handling 설정  "3구 신호등
  gs_layout-excp_led = 'X'.                " 신호등 모양 변경 - 1구 신호등 옵션 - led light

  gs_layout-info_fname = 'ROW_COLOR'.      "line ROW 컬러.
  gs_layout-ctab_fname = 'COLOR'.       "Cell의 컬러.
  gs_layout-stylefname = 'BT'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form make_field_catalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_field_catalog .

  CLEAR gs_fcat.
  "I&D field catalog 추가.
  gs_fcat-fieldname = 'FLTDI'.
  gs_fcat-coltext   = 'I&D'.
  gs_fcat-col_opt   = 'X'.
  gs_fcat-col_pos   = 5.
  gs_fcat-just      = 'C'.           "중앙정렬.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "Flight Type field catalog 추가.
  gs_fcat-fieldname = 'FLTYPE_ICON'.
  gs_fcat-coltext   = 'FLIGHT'.
  gs_fcat-col_pos   = 9.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "From TZone catalog 추가.
  gs_fcat-fieldname = 'F_TZONE'.
  gs_fcat-coltext   = 'From TZ'.
  gs_fcat-col_pos   = 17.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "To TZone catalog 추가.
  gs_fcat-fieldname = 'T_TZONE'.
  gs_fcat-coltext   = 'To TZ'.
  gs_fcat-col_pos   = 18.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "ARRIVAL TIME Column color highlight.
  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C610'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "ARRIVAL TIME Column color highlight.
  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C610'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  " FLIGHT TIME 수정가능 모드 추가.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit      = p_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  " FLIGHT TIME 수정가능 모드 추가.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit      = p_edit.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MODI
*&---------------------------------------------------------------------*
FORM modify_check  USING VALUE(p_modi) TYPE lvc_s_modi.
  READ TABLE gt_spfli INTO gs_spfli INDEX p_modi-row_id.
  IF sy-subrc = 0.
    gs_spfli-modified = 'X'.
    MODIFY gt_spfli FROM gs_spfli INDEX p_modi-row_id.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save.

*  CALL FUNCTION 'POPUP_TO_CONFIRM'
*    EXPORTING
*      titlebar              = pv_text1
*      text_question         = pv_text2.
*      text_question         = pv_text2.
**      text_button_1         = 'Yes'
**      text_button_2         = 'No'
**      display_cancel_button = ''
*    IMPORTING
*      answer                = cv_result
*    EXCEPTIONS
*      text_not_found        = 1
*      OTHERS                = 2.
*  IF sy-subrc <> 0.
**     Implement suitable error handling here
*  ELSE.
*    IF gv_ans = '1'.


*  --Update/업데이트 대상--*
      LOOP AT gt_spfli INTO gs_spfli WHERE modified = 'X'.

        UPDATE ztspfli_a11
           SET fltime   = gs_spfli-fltime
               deptime  = gs_spfli-deptime
               arrtime  = gs_spfli-arrtime
               period   = gs_spfli-period
         WHERE carrid   = gs_spfli-carrid
           AND connid   = gs_spfli-connid.

      ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  DATA : gv_result .
  PERFORM ask_save USING TEXT-003 TEXT-004
            CHANGING gv_result.
  IF gv_result = '1'.
    CALL METHOD go_alv->free.
    CALL METHOD go_container->free.
    FREE : go_alv, go_container.

    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form ask_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> TEXT_003
*&      --> TEXT_004
*&      <-- GV_RESULT
*&---------------------------------------------------------------------*
FORM ask_save USING pv_text1 pv_text2
              CHANGING cv_result TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar      = pv_text1
      text_question = pv_text2
    IMPORTING
      answer        = cv_result.
ENDFORM.
