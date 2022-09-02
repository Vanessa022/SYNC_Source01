*&---------------------------------------------------------------------*
*& Include          ZBC405_T3_ALV_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS :
      on_doubleclick FOR EVENT double_click
        OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      on_hotspot FOR EVENT hotspot_click
        OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,
      on_toolbar FOR EVENT toolbar
        OF  cl_gui_alv_grid
        IMPORTING e_object,
      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_button_click FOR EVENT button_click
        OF cl_gui_alv_grid
        IMPORTING es_col_id  es_row_no,
      on_print_top    FOR EVENT print_top_of_page
        OF cl_gui_alv_grid,
      on_print_tol    FOR EVENT print_top_of_list
        OF cl_gui_alv_grid,
      on_context_menu_request FOR EVENT context_menu_request
        OF cl_gui_alv_grid
        IMPORTING e_object,
      on_before_user_com FOR EVENT before_user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_data_changed FOR EVENT data_changed
        OF cl_gui_alv_grid
        IMPORTING er_data_changed.


ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD on_data_changed.



    DATA : ls_mod_cells TYPE lvc_s_modi.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells.

      CASE ls_mod_cells-fieldname.
        WHEN 'SEATSOCC'.
          PERFORM SEATSOCC_change_part USING er_data_changed
                                       ls_mod_cells.

      ENDCASE.
    ENDLOOP.



  ENDMETHOD.

  METHOD on_before_user_com.

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.
        CALL METHOD go_alv_grid->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.     "flight schedule report

    ENDCASE.


  ENDMETHOD.

  METHOD on_context_menu_request.


    DATA : lv_col_id TYPE lvc_s_col,
           lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    IF lv_col_id-fieldname = 'CARRID'.

*    CALL METHOD e_object->add_separator.
*
*
*    CALL METHOD cl_ctmenu=>load_gui_status
*      EXPORTING
*        program    = sy-cprog
*        status     = 'CT_MENU'
**       disable    =
*        menu       = e_object
*      EXCEPTIONS
*        read_error = 1
*        OTHERS     = 2.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.


      CALL METHOD e_object->add_separator.

      CALL METHOD e_object->add_function
        EXPORTING
          fcode = 'DIS_CARR'
          text  = 'Display Airline'
*         icon  =
*         ftype =
*         disabled          =
*         hidden            =
*         checked           =
*         accelerator       =
*         insert_at_the_top = SPACE
        .

    ENDIF.

  ENDMETHOD.


  METHOD on_print_top.
    WRITE : / sy-datum, sy-uzeit.
  ENDMETHOD.

  METHOD on_print_tol.

    WRITE : / so_car-low.

  ENDMETHOD.

  METHOD on_button_click.

    CASE es_col_id-fieldname.

      WHEN 'BTN_TEXT'.
        READ TABLE gt_flt INTO gs_flt
              INDEX es_row_no-row_id.
        IF ( gs_flt-seatsmax NE gs_flt-seatsocc ) OR
           ( gs_flt-seatsmax_f NE gs_flt-seatsocc_f ).

          MESSAGE i000(zt03_msg) WITH '다른 등급의 좌석을 예약하세요!'.
        ELSE.

          MESSAGE i000(zt03_msg) WITH '모든 좌석이 예약이 된 상태입니다.'.
        ENDIF.


    ENDCASE.

  ENDMETHOD.



  METHOD on_user_command.

    DATA : lv_occp     TYPE i,
           lv_capa     TYPE i,
           lv_perct    TYPE p LENGTH 8 DECIMALS 1,
           lv_text(20).

    DATA : lt_rows TYPE lvc_t_roid,
           ls_rows TYPE lvc_s_roid.


    DATA : lv_col_id TYPE lvc_s_col,
           lv_row_id TYPE lvc_s_row.

    CLEAR : lv_text.
    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    CASE e_ucomm.

      WHEN 'SCHE'.      "goto flight schedule report.
        READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
        IF sy-subrc EQ 0.
          SUBMIT bc405_event_d4 AND RETURN
*                   VIA SELECTION-SCREEN
                WITH so_car EQ gs_flt-carrid
                WITH so_con EQ gs_flt-connid.
        ENDIF.

      WHEN 'DIS_CARR'.
        IF  lv_col_id-fieldname = 'CARRID'.

          READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
          IF sy-subrc EQ 0.
            CLEAR : lv_text.
            SELECT SINGLE carrname INTO lv_text FROM scarr
                     WHERE carrid = gs_flt-carrid.
            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.

          ENDIF.
        ELSE.
          MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
          EXIT.
        ENDIF.



      WHEN 'PERCENTAGE'.
        LOOP AT gt_flt INTO gs_flt.
          lv_occp = lv_occp + gs_flt-seatsocc.
          lv_capa = lv_capa + gs_flt-seatsmax.
        ENDLOOP.

        lv_perct = lv_occp / lv_capa * 100.
        lv_text = lv_perct.
        CONDENSE lv_text.

        MESSAGE i000(zt03_msg) WITH
            'Percentage of occupied seats (%):' lv_text.

      WHEN 'PERCENTAGE_MARKED'.

        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*           et_index_rows =
            et_row_no = lt_rows.

        IF lines( lt_rows ) > 0.
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
            IF sy-subrc EQ 0.
              lv_occp = lv_occp + gs_flt-seatsocc.
              lv_capa = lv_capa + gs_flt-seatsmax.

            ENDIF.

          ENDLOOP.

          lv_perct = lv_occp / lv_capa * 100.
          lv_text = lv_perct.
          CONDENSE lv_text.

          MESSAGE i000(zt03_msg) WITH
              'Percentage of Marked occupied seats (%):' lv_text.

        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least one line!'.
        ENDIF.

    ENDCASE.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA : ls_button TYPE stb_button.
    CLEAR : ls_button .
    ls_button-function = 'DIS_CARR'.
    ls_button-icon = icon_ws_plane.
    ls_button-quickinfo = 'Airline Name'.
    ls_button-butn_type = '0'.    "normal button
*    ls_button-text = ''.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


    CLEAR : ls_button .
    ls_button-butn_type = '3'.    "seperator
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


    CLEAR : ls_button .
    ls_button-function = 'PERCENTAGE'.
*     ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Total Percentage'.
    ls_button-butn_type = '0'.    "normal button
    ls_button-text = 'Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.



    CLEAR : ls_button .
    ls_button-function = 'PERCENTAGE_MARKED'.
*     ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Marked Percentage'.
    ls_button-butn_type = '0'.    "normal button
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


  ENDMETHOD.

  METHOD on_hotspot.

    DATA : carr_name TYPE scarr-carrname.

    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
          SELECT SINGLE carrname INTO carr_name FROM scarr
                   WHERE carrid = gs_flt-carrid.
          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'No found!'.
          ENDIF.

        ELSE.
          MESSAGE i075(bc405_408).
          EXIT.
        ENDIF.

    ENDCASE.
  ENDMETHOD.



  METHOD on_doubleclick.
    DATA : total_occ TYPE i.
    DATA : total_occ_c TYPE c LENGTH 10.


    CASE e_column-fieldname.
      WHEN 'CHANGES_POSSIBLE'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
          total_occ = gs_flt-seatsocc +
                      gs_flt-seatsocc_b +
                      gs_flt-seatsocc_f.

          total_occ_c = total_occ.
          CONDENSE total_occ_c.
          MESSAGE i000(zt03_msg) WITH 'Total number of bookings:'
                           total_occ_c.
        ELSE.
          MESSAGE i075(bc405_408).
          EXIT.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
