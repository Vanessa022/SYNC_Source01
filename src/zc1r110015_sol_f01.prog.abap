*&---------------------------------------------------------------------*
*& Include          ZC1R260007_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_emp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_emp_data .

  CLEAR   gs_emp.
  REFRESH gt_emp.

  SELECT pernr ename entdt gender depid carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    FROM ztsa1101
   WHERE pernr IN so_pernr.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'PERNR'   ' '   'ZTSA1101'    'PERNR'    'X'  10,
    ' '   'ENAME'   ' '   'ZTSA1101'    'ENAME'    'X'  20,
    ' '   'ENTDT'   ' '   'ZTSA1101'    'ENTDT'    'X'  10,
    ' '   'GENDER'  ' '   'ZTSA1101'    'GENDER'   'X'  5,
    ' '   'DEPID'   ' '   'ZTSA1101'    'DEPID'    'X'  8,
    ' '   'CARRID'  ' '   'ZTSA1101'    'CARRID'   'X'  10.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_edit
                     pv_length.

  gt_fcat = VALUE #( BASE gt_fcat
                     (
                       key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                       edit      = pv_edit
                       outputlen = pv_length
                     )
                   ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_emp
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .

  CLEAR gs_emp.

  APPEND gs_emp TO gt_emp.

  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_emp .

  DATA : lt_save  TYPE TABLE OF ztsa1101,
         lt_del   TYPE TABLE OF ztsa1101,
         lv_cnt   TYPE i,
         lv_error.

  REFRESH: lt_save, lt_del.

  CALL METHOD gcl_grid->check_changed_data. "ALV의 입력된 값을 ITAB으로 반영시킴.

  CLEAR lv_error. "필수 입력값 입력 여부 체크.
  LOOP AT gt_emp INTO gs_emp.

    IF gs_emp-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'.   "에러발생 했을 경우 저장 플로우 수행방지 위해서 값을 세팅.
      EXIT.             "현재 수행중인 루틴을 빠져나감 : 지금은 LOOP 를 빠져나감.
    ENDIF.

    lt_save = VALUE #( BASE lt_save "에러 없는 데이터는 저장할 ITAB에 데이터 저장.
                       (
                         pernr  = gs_emp-pernr
                         ename  = gs_emp-ename
                         entdt  = gs_emp-entdt
                         gender = gs_emp-gender
                         depid  = gs_emp-depid
                         carrid = gs_emp-carrid
                       )
                     ).
  ENDLOOP.

*  CHECK lv_error IS INITIAL. " 에러가 없었으면 아래 로직 수행.
  IF lv_error IS NOT INITIAL. " 에러가 있었으면 현재 루틴 빠져나감.
    EXIT.
  ENDIF.

  IF  gt_emp_del IS NOT INITIAL.

    LOOP AT gt_emp_del INTO DATA(ls_del).

      lt_del = VALUE #( BASE lt_del
                        ( pernr = ls_del-pernr )
                      ).
    ENDLOOP.

    DELETE ztsa1101 FROM TABLE lt_del.

    IF  sy-dbcnt > 0.
      lv_cnt = lv_cnt + sy-dbcnt.
    ENDIF.

  ENDIF.

  IF lt_save IS NOT INITIAL.

    MODIFY ztsa1101 FROM TABLE lt_save.

    IF sy-dbcnt > 0.
      lv_cnt += sy-dbcnt.
      MESSAGE s002. "Data 저장 성공 메시지.
    ENDIF.

  ENDIF.

  IF lv_cnt > 0.
   COMMIT WORK AND WAIT.
    MESSAGE s002.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH gt_rows.

  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

  IF  gt_rows IS INITIAL.   "행을 선택 했는지 체크.
    MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

*  LOOP AT gt_rows INTO gs_row.
*
*    READ TABLE gt_emp INTO gs_emp INDEX gs_row-index.
*
*    IF sy-subrc = 0.
*      gs_emp-mark = 'X'.
*
*      MODIFY gt_emp FROM gs_emp INDEX gs_row-index
*     TRANSPORTING mark.
*    ENDIF.
*
*  ENDLOOP.
*
**  DELETE gt_emp WHERE mark = 'X'.
*  DELETE gt_emp WHERE mark IS NOT INITIAL.

  SORT gt_rows BY index DESCENDING.

  LOOP AT gt_rows INTO gs_row.

* ITAB에서 삭제 하기전에 DB테이블에서도 삭제해야 하므로
*삭제 대상을 따로 보관.

    READ TABLE gt_emp INTO gs_emp INDEX gs_row-index.

    IF  sy-subrc = 0.

      APPEND gs_emp TO gt_emp_del.  " 삭제 대상을 삭제 ITAB에 보관.

    ENDIF.

    DELETE gt_rows INDEX gs_row-index.

  ENDLOOP.

  PERFORM refresh_grid.   "변경된 ITAB을 ALV에 반영.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style .

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl.

*    ls_style-fieldname = 'PERNR'.
*    ls_style-style = cl_gui_alv_grid=>mc_style_disabled

    ls_style = VALUE #( fieldname = 'PERNR'
                       style     = cl_gui_alv_grid=>mc_style_disabled ).

* Table 에서 사지고 온 데이터의 PK는 변경 방지 위해서 편집금지모드로
  LOOP AT gt_emp INTO gs_emp.
    lv_tabix = sy-tabix.

    REFRESH gs_emp-style.

    APPEND ls_style TO gs_emp-style.

    MODIFY gt_emp FROM gs_emp INDEX lv_tabix
    TRANSPORTING style.

  ENDLOOP.

ENDFORM.
