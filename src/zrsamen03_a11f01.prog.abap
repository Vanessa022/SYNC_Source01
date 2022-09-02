*&---------------------------------------------------------------------*
*& Include          ZRSAMAR02F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_high.
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
  gs_fcat-col_pos = 1.
  APPEND gs_fcat TO gt_fcat_high.
*
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRNAME'.
  gs_fcat-coltext = 'CARRNAME'.
  gs_fcat-fix_column = 'X'.
  gs_fcat-col_pos = 2.
  APPEND gs_fcat TO gt_fcat_high.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout_high
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout_high .
  gs_layout_high-zebra = 'X'.
  gs_layout_high-cwidth_opt = 'X'.
  gs_layout_high-sel_mode = 'D'.
  gs_layout_high-grid_title = 'TABLE - SFLIGHT'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_low
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_low .
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
  gs_fcat-col_pos = 1.
  APPEND gs_fcat TO gt_fcat_low.
*
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRNAME'.
  gs_fcat-coltext = 'CARRNAME'.
  gs_fcat-fix_column = 'X'.
  gs_fcat-col_pos = 2.
  APPEND gs_fcat TO gt_fcat_low.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout_low
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout_low .
  gs_layout_low-cwidth_opt = 'X'.
  gs_layout_low-sel_mode = 'C'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form Down
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM down .
  DATA : lt_rows    TYPE lvc_t_row,
         ls_rows    TYPE lvc_s_row,
         ls_sflight TYPE sflight,
         lv_subrc   TYPE sy-subrc,
         lv_line    TYPE i.
  CLEAR      lt_rows.
  CALL METHOD go_alv_grid_high->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  CLEAR lv_subrc.
  IF lt_rows IS INITIAL.
    CALL METHOD go_alv_grid_high->get_current_cell
      IMPORTING
        e_row = lv_line.
    READ TABLE gt_sflight_high INTO gs_sflight INDEX lv_line.

    READ TABLE gt_sflight_low INTO ls_sflight WITH KEY carrid = gs_sflight-carrid connid = gs_sflight-connid fldate = gs_sflight-fldate.
    IF sy-subrc EQ 0.
      MESSAGE i016(pn) WITH '이미 존재하는 데이터입니다'.
    ENDIF.
  ELSE.
    LOOP AT lt_rows INTO ls_rows.
      CLEAR gs_sflight.
      READ TABLE gt_sflight_high INTO gs_sflight INDEX ls_rows-index.

      READ TABLE gt_sflight_low INTO ls_sflight WITH KEY carrid = gs_sflight-carrid connid = gs_sflight-connid fldate = gs_sflight-fldate.
      IF sy-subrc EQ 0.
        lv_subrc = 4.
      ELSE.
        APPEND gs_sflight TO gt_sflight_low.
      ENDIF.
    ENDLOOP.

    IF lv_subrc <> 0.
      MESSAGE i016(pn) WITH '중복된 데이터를 제외하고 추가됩니다.'.
    ENDIF.
  ENDIF.
ENDFORM.
