*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_CL1_A11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alv_cl1_a11.


TABLES: ztsbook_A11.


*---------------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR ztsbook_a11-carrid OBLIGATORY MEMORY ID car,
                  so_con FOR ztsbook_a11-connid            MEMORY ID con,
                  so_fld FOR ztsbook_a11-fldate,
                  so_cus FOR ztsbook_a11-customid.


  SELECTION-SCREEN SKIP.

  PARAMETERS: p_edit AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN SKIP.

PARAMETERS: p_layout TYPE disvariant-variant.

DATA : gt_custom TYPE TABLE OF ztscustom_A11,
       gs_custom TYPE          ztscustom_A11.



*---------------------------------------------------------------------------
TYPES: BEGIN OF gty_book.
         INCLUDE TYPE ztsbook_a11.
TYPES:   light TYPE c LENGTH 1.           "신호등 역할 위해 선언.
TYPES:   telephone TYPE ztscustom_a11-telephone.
TYPES:   email     TYPE ztscustom_a11-email.
TYPES:   row_color TYPE c LENGTH 4.        " ROW 색 칠하기 위해 선언.
TYPES:   it_color  TYPE lvc_t_scol.        " cell 컬러 바꾸기 위한 타입.
TYPES:   bt        TYPE lvc_t_styl.        " Field Symmbol.
TYPES:   modified  TYPE c LENGTH 1.        " Record 변경되면 'X'.
TYPES: END OF gty_book.

DATA: gt_sbook TYPE TABLE OF gty_book,
*      dl_sbook TYPE TABLE OF gty_book,     " for deleting record.
      gs_sbook TYPE          gty_book.

DATA: dl_sbook TYPE TABLE OF ztsbook_a11,
      dw_sbook TYPE          ztsbook_a11.

DATA: ok_code TYPE sy-ucomm.


*-- FOR ALV 변수 --*
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_layout  TYPE lvc_s_layo,
      gt_sort    TYPE lvc_t_sort,      "Headerline.
      gs_sort    TYPE lvc_s_sort,      "Work Area.
      gs_color   TYPE lvc_s_scol,      "Work Area for it_color.
      gt_exct    TYPE ui_functions,    "TOOLBAR EXCLUDING.
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat.

DATA: rt_tab TYPE zz_range_type.
DATA: rs_tab TYPE zst03_carrid.


INCLUDE ZBC405_alv_cl1_a11_class.



*---------------------------------------------------------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.      " for Search Help.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'    "S :save, L :load  F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout      = gs_variant-variant.
  ENDIF.


INITIALIZATION.
  gs_variant-report = sy-cprog.

  rs_tab-low = 'AA'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.

  rs_tab-low = 'LH'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.

  rs_tab-low = 'AZ'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.

  so_car[] = rt_tab[].


START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.





*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: gt_temp TYPE TABLE OF gty_book.

  SELECT *
    FROM ztsbook_a11
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
   WHERE carrid   IN so_car
     AND connid   IN so_con
     AND fldate   IN so_fld
     AND customid IN so_cus.

  IF sy-subrc = 0.

    gt_temp = gt_sbook.
    DELETE gt_temp WHERE customid = space.

    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid.

    SELECT *
      FROM ztscustom_a11
      INTO TABLE gt_custom
      FOR ALL ENTRIES IN gt_temp
      WHERE id = gt_temp-customid.

  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom INTO gs_custom
    WITH KEY id = gs_sbook-customid.

    IF sy-subrc = 0.
      gs_sbook-telephone = gs_custom-telephone.
      gs_sbook-email     = gs_custom-email.
    ENDIF.


*-- exception handling

    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1.           "Red.

    ELSEIF gs_sbook-luggweight > 15.
      gs_sbook-light = 2.           "Yellow.

    ELSE.
      gs_sbook-light = 3.           "Green.
    ENDIF.


*-- row color

    IF gs_sbook-class = 'F'.        "First Class.
      gs_sbook-row_color = 'C310'.  "Color 설정.  [C]olor [3]Yellow [1]진하게 [0]Inverted.
    ENDIF.


*-- Cell Color - SMOKER CELL 빨간색 표시.
    IF gs_sbook-smoker = 'X'.
      gs_color-fname = 'SMOKER'.
      gs_color-color-col = col_negative.   "Red.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_sbook-it_color.

    ENDIF.

    MODIFY gt_sbook FROM gs_sbook.

  ENDLOOP.

ENDFORM.





*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF p_edit = 'X'.
    SET PF-STATUS 'T100'.                   "edit mode 일 때는 Save 버튼 보여라.
  ELSE.
    SET PF-STATUS 'T100' EXCLUDING 'SAVE'.  "edit mode 아닐땐 세이브 버튼 숨겨라.
  ENDIF.

  SET TITLEBAR 'T10' WITH sy-datum sy-uname.
ENDMODULE.





*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.





*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.

  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.


    IF sy-subrc = 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

      IF sy-subrc = 0.


        PERFORM set_variant.
        PERFORM set_layout.
        PERFORM set_sort.
        PERFORM make_field_catalog.


*---
        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.           " 변경되는순간반영.
*---
        "mc_evt_enter   "enter

        APPEND cl_gui_alv_grid=>mc_fc_filter          TO gt_exct.    " 필터 버튼 안보이게 한다.
        APPEND cl_gui_alv_grid=>mc_fc_info            TO gt_exct.    " 인포 버튼 안보이게 한다.
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row  TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row    TO gt_exct.


        SET HANDLER lcl_handler=>on_doubleclick           FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar               FOR go_alv.
        SET HANDLER lcl_handler=>on_usercommand           FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed          FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finish   FOR go_alv.


        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A11'
            is_variant           = gs_variant
            i_save               = 'A'         " ' '(자체 변경만 가능) , A(글로벌&로컬 둘다 설정 가능), X(글로벌만 설정 가능), U(로컬만 설정 가능).
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
            it_outtab            = gt_sbook
            it_fieldcatalog      = gt_fcat
            it_sort              = gt_sort
*           it_filter            =
*           EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*                 Implement suitable error handling here
        ENDIF.
      ENDIF.
    ENDIF.

  ELSE.


    DATA:
      gs_staBle       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.

*  -- refresh alv method 올 자리. --*

    gV_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
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

  gs_layout-sel_mode = 'D'.                " A, B, C, D
  gs_layout-excp_fname = 'LIGHT'.          " 신호등 역할 - exceptiona handling.
* gs_layout-excp_led   = 'X'.             " 신호등 아이콘 변경 (1구).
  gs_layout-zebra      = 'X'.              " Row Zebra Pattern.
  gs_layout-cwidth_opt = 'X'.              " Coloumn Width Optimztion.

  gs_layout-info_fname = 'ROW_COLOR'.      "Row COLOR 필드 설정.
  gs_layout-ctab_fname = 'IT_COLOR'.       " Cell Color
  gs_layout-stylefname = 'BT'.             "Field Symbol style 설정.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .

*-- SORT     " 반복되는 내용은 한번만 표시되게 하는 기능.
  CLEAR gt_sort.
  gs_sort-fieldname   = 'CARRID'.
  gs_sort-up         = 'X'.   " 오름차순.
  gs_sort-spos       = '1'.   " 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gt_sort.
  gs_sort-fieldname   = 'CONNID'.
  gs_sort-up         = 'X'.
  gs_sort-spos       = '2'.
  APPEND gs_sort TO gt_sort.

  CLEAR gt_sort.
  gs_sort-fieldname   = 'FLDATE'.
  gs_sort-down       = 'X'.   " 내림차순.
  gs_sort-spos       = '3'.
  APPEND gs_sort TO gt_sort.

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

  CLEAR: gs_fcat.
  " Light Column name is changed to INFO
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'INFO'.      "Coloumn heading Text
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  "Smoker Coloumn changed to checkbox
  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  "INVOICE Coloumn changed to checkbox
  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  "CANCELED FLAG Coloumn changed to checkbox
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit     = p_edit.    "수정 가능.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "TELEOPHONE field catalog 추가.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_T03'.
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-col_pos   = '30'.       " Column Output 순서.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  "EMAIL field catalog 추가.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_T03'.
  gs_fcat-ref_field = 'EMAIL'.
  gs_fcat-col_pos = '31'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  "CUSTOMID field column 컬러 변경.
  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C400'.
  gs_fcat-edit      = p_edit.    "수정 가능 - edit mode 테크하면 edit mode로 들어감.
  APPEND gs_fcat TO gt_fcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM customer_change_part  USING per_data_changed
                           TYPE REF TO cl_alv_changed_data_protocol
                                 ps_mod_cells TYPE lvc_s_modi.

  DATA: l_customid TYPE ztsbook_a11-customid.
  DATA: l_phone    TYPE ztscustom_a11-telephone.
  DATA: l_email    TYPE ztscustom_a11-email.
  DATA: l_name     TYPE ztscustom_a11-name.

  READ TABLE: gt_sbook INTO gs_sbook INDEX ps_mod_cells-row_id.

  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'CUSTOMID'
    IMPORTING
      e_value     = l_customid.


  IF l_customid IS NOT INITIAL.

    READ TABLE gt_custom INTO gs_custom
               WITH KEY id = l_customid.

    IF sy-subrc = 0.
      l_phone = gs_custom-telephone.
      l_email = gs_custom-email.
      l_name  = gs_custom-name.

    ELSE.
      SELECT SINGLE Telephone email name
        FROM ztscustom_a11
        INTO (l_phone, l_email, l_name)
        WHERE id = l_customid.

    ENDIF.
  ELSE.
    CLEAR: l_email, l_phone, l_name.
  ENDIF.


  " display 화면에 보이는 정보를 modify 해라.
  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'TELEPHONE'
      i_value     = l_phone.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'EMAIL'
      i_value     = l_email.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'PASSNAME'
      i_value     = l_NAME.


  gs_sbook-email = l_email.
  gs_sbook-telephone = l_phone.
  gs_sbook-passname = l_name.

  " 실제 internal table도 modify 해라.
  MODIFY gt_sbook FROM gs_sbook
  INDEX ps_mod_cells-row_id.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING    rr_data_changed
                            TYPE REF TO cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce.

  gs_sbook-carrid = so_car-low.     "so_car_sign = 'I'  so_car-option = 'EQ'.
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.


  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CUSTTYPE'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CLASS'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'DISCOUNT'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'SMOKER'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'LUGGWEIGHT'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'WUNIT'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'INVOICE'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'FORCURAM'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'FORCURKEY'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'LOCCURAM'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'LOCCURKEY'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'ORDER_DATE'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'AGENCYNUM'.


  MODIFY gt_sbook FROM gs_sbook INDEX Rs_ins_cells-row_id .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RR_DATA_CHANGED
*&      --> RS_INS_CELLS
*&      --> P_
*&---------------------------------------------------------------------*
FORM modify_style  USING    rr_data_changed  TYPE REF TO cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce
                            VALUE(p_val).


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = p_val
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    pls_mod_cells TYPE lvc_s_modi.

  READ TABLE gt_sbook INTO gs_sbook INDEX pls_mod_cells-row_id.
  IF sy-subrc = 0.
    gs_sbook-modified = 'X'.
    MODIFY gt_sbook FROM gs_sbook INDEX pls_mod_cells-row_id.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA: p_ans TYPE c LENGTH 1.

  CASE ok_code.

    WHEN 'SAVE'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Data Save!'
          text_question         = 'Do you want to Save?'
          text_button_1         = 'Yes'
          text_button_2         = 'No'
          display_cancel_button = ' '
        IMPORTING
          answer                = p_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        IF p_ans = '1'.

          PERFORM data_save.

        ENDIF.
      ENDIF.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  DATA: ins_sbook TYPE TABLE OF ztsbook_a11,
        wa_sbook  TYPE ztsbook_a11.


*--Update/업데이트 대상--*
  LOOP AT gt_sbook INTO gs_sbook WHERE modified = 'X'.

    UPDATE ztsbook_a11
       SET customid   = gs_sbook-customid
           cancelled  = gs_sbook-cancelled
           passname   = gs_sbook-passname
     WHERE carrid = gs_sbook-carrid
       AND connid = gs_sbook-connid
       AND fldate = gs_sbook-fldate
       AND bookid = gs_sbook-bookid.

  ENDLOOP.



*-- Insert 부분 --*
  DATA: next_number TYPE s_book_id,
        ret_code    TYPE inri-returncode.

  DATA: l_tabix     LIKE sy-tabix.

  LOOP AT gt_sbook INTO gs_sbook WHERE bookid IS INITIAL.

    l_tabix = sy-tabix.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr   = '01'
        object        = 'ZBOOKIDA11'
        subobject     = gs_sbook-carrid
        ignore_buffer = ' '
      IMPORTING
        number        = next_number
*       QUANTITY      =
        RETURNCODE    = ret_code
     EXCEPTIONS
       INTERVAL_NOT_FOUND            = 1
       NUMBER_RANGE_NOT_INTERN       = 2
       OBJECT_NOT_FOUND              = 3
       QUANTITY_IS_0                 = 4
       QUANTITY_IS_NOT_1             = 5
       INTERVAL_OVERFLOW             = 6
       BUFFER_OVERFLOW               = 7
       OTHERS                        = 8
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here

    ELSE.
        IF next_number IS NOT INITIAL.

           gs_sbook-bookid = next_number.

           MOVE-CORRESPONDING gs_sbook TO wa_sbook.
           APPEND wa_sbook TO ins_sbook.

           MODIFY gt_sbook FROM gs_sbook INDEX l_tabix
           TRANSPORTING bookid.

        ENDIF.
    ENDIF.
  ENDLOOP.

  IF ins_sbook IS NOT INITIAL.
    INSERT ztsbook_a11 FROM TABLE ins_sbook.
  ENDIF.



*-- Delete --*
 IF dl_SBOOk IS NOT INITIAL.
    DELETE ztsbook_a11 FROM TABLE ins_sbook.

    CLEAR: dl_sbook. REFRESH: dl_sbook.
 ENDIF.

 ENDFORM.
