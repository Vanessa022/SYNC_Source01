*&---------------------------------------------------------------------*
*& Include          ZBC405_A11_EXAM01_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:

      on_toolbar FOR EVENT
        toolbar OF cl_gui_alv_grid
        IMPORTING e_object,

      on_usercommand FOR EVENT
        user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_doubleclick FOR EVENT
        double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      on_data_changed FOR EVENT
        data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      on_data_changed_finish FOR EVENT
        data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.

      endclass.

    CLASS lcl_handler IMPLEMENTATION.
    METHOD on_toolbar.
      DATA:ls_button TYPE stb_button.
*
      ls_button-butn_type = '3'.                "Separator.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.
*
      CLEAR: ls_button.
      ls_button-butn_type   = '0'.
      ls_button-function     = 'FLTNAME'.
      ls_button-icon        = ICON_Flight.
      ls_button-quickinfo  = 'Airline Name'.
      ls_button-text        = 'Flight'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.

      CLEAR: ls_button.
      ls_button-butn_type   = '0'.
      ls_button-function     = 'FLTINFO'.
      ls_button-quickinfo  = 'FLIGHT Info'.
      ls_button-text        = 'Flight Info'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.

      CLEAR: ls_button.
      ls_button-butn_type   = '0'.
      ls_button-function     = 'FLTDATA'.
      ls_button-quickinfo  = 'FLIGHT Data'.
      ls_button-text        = 'Flight Data'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.
    ENDMETHOD.


    METHOD on_usercommand.

      DATA: ls_col  TYPE lvc_s_col,
            ls_roid TYPE lvc_s_roid.


      DATA: carrname TYPE scarr-carrname.

      DATA: lt_rows  TYPE lvc_t_row,
            ls_rows  LIKE LINE OF lt_rows,
            xt_spfli TYPE TABLE OF spfli,
            ws_spfli LIKE LINE OF  xt_spfli.

      "FLTNAME - Airline Name MSG
      CALL METHOD go_alv->get_current_cell
        IMPORTING
          es_col_id = ls_col
          es_row_no = ls_roid.

      "FLTINFO - CALL PROGRAM 'SAPBC410A_INPUT_FIEL'.
      "FLTDATA - Call Transaction 'SAPBC410A_INPUT_FIEL'
      CALL METHOD go_alv->get_selected_rows
        IMPORTING
          et_index_rows = lt_rows.
*        et_row_no     =


      CASE e_ucomm.
        WHEN 'FLTNAME'.
          READ TABLE gt_spfli INTO gs_spfli
               INDEX ls_roid-row_id.
          IF sy-subrc = 0.

            SELECT SINGLE carrname
              FROM scarr
              INTO carrname
             WHERE carrid = gs_spfli-carrid.

              IF sy-subrc = 0.
                MESSAGE i000(zt03_msg) WITH carrname.
              ENDIF.
            ENDIF.



          WHEN 'FLTINFO'.
            LOOP AT lt_rows INTO ls_rows.
              READ TABLE gt_spfli INTO gs_spfli INDEX ls_rows-index.

              IF sy-subrc = 0.
                MOVE-CORRESPONDING gs_spfli TO ws_spfli.
                APPEND ws_spfli TO xt_spfli.
              ENDIF.
            ENDLOOP.

            IF sy-subrc = 0.
              EXPORT mem_it_spfli FROM xt_spfli TO MEMORY ID 'BC405'.

              SUBMIT bc405_call_flights AND RETURN.
            ENDIF.



          WHEN 'FLTDATA'.
            READ TABLE gt_spfli INTO gs_spfli
            INDEX ls_roid-row_id.

            IF sy-subrc = 0.
              SET PARAMETER ID 'CAR' FIELD gs_spfli-carrid.
              SET PARAMETER ID 'CON' FIELD gs_spfli-connid.

              CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.

            ENDIF.
        ENDCASE.
      ENDMETHOD.


      METHOD on_doubleclick.
        DATA : ls_col    TYPE lvc_s_col,
               ls_row_no TYPE lvc_s_roid,
               lv_value  TYPE c LENGTH 20.

        CALL METHOD go_alv->get_current_cell
          IMPORTING
*           e_row     =
            e_value   = lv_value
*           e_col     =
*           es_row_id =
            es_col_id = ls_col
            es_row_no = ls_row_no.

        CASE ls_col-fieldname.
          WHEN 'CARRID' OR 'CONNID'.
            READ TABLE gt_spfli INTO gs_spfli INDEX ls_row_no-row_id.
            SUBMIT bc405_event_s4 WITH so_car = gs_spfli-carrid
                                  WITH so_con = gs_spfli-connid.

        ENDCASE.
      ENDMETHOD.


      METHOD on_data_changed.
        DATA: ls_mod_cells TYPE lvc_s_modi,
              lv_fltime    TYPE ztspfli_a11-fltime,
              lv_deptime   TYPE ztspfli_a11-deptime,
              lv_arrtime   TYPE spfli-arrtime,
              lv_period    TYPE n,
              lv_light     TYPE c LENGTH 1.

        LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cells.
          CASE ls_mod_cells-fieldname.
            WHEN 'FLTIME' OR 'DEPTIME'.

              READ TABLE gt_spfli INTO gs_spfli INDEX ls_mod_cells-row_id.

              CALL METHOD er_data_changed->get_cell_value
                EXPORTING
                  i_row_id    = ls_mod_cells-row_id
*                 i_tabix     =
                  i_fieldname = 'FLTIME'
                IMPORTING
                  e_value     = lv_fltime.

              CALL METHOD er_data_changed->get_cell_value
                EXPORTING
                  i_row_id    = ls_mod_cells-row_id
*                 i_tabix     =
                  i_fieldname = 'DEPTIME'
                IMPORTING
                  e_value     = lv_deptime.

              CALL FUNCTION 'ZBC405_CALC_ARRTIME'
                EXPORTING
                  iv_fltime       = lv_fltime
                  iv_deptime      = lv_deptime
                  iv_utc          = gs_spfli-f_tzone
                  iv_utc1         = gs_spfli-t_tzone
                IMPORTING
                  ev_arrival_time = lv_arrtime
                  ev_period       = lv_period.

              IF      lv_period = 0.
                lv_LIGHT = 3.
              ELSEIF  lv_period = 1.
                lv_LIGHT = 2.
              ELSEIF lv_period >= 2.
                lv_LIGHT = 1.
              ENDIF.


              CALL METHOD er_data_changed->modify_cell
                EXPORTING
                  i_row_id    = ls_mod_cells-row_id
*                 i_tabix     =
                  i_fieldname = 'ARRTIME'
                  i_value     = lv_arrtime.

              CALL METHOD er_data_changed->modify_cell
                EXPORTING
                  i_row_id    = ls_mod_cells-row_id
*                 i_tabix     =
                  i_fieldname = 'PERIOD'
                  i_value     = lv_period.

              CALL METHOD er_data_changed->modify_cell
                EXPORTING
                  i_row_id    = ls_mod_cells-row_id
*                 i_tabix     =
                  i_fieldname = 'LIGHT'
                  i_value     = lv_LIGHT.

              gs_spfli-fltime   = lv_fltime.
              gs_spfli-deptime  = lv_deptime.
              gs_spfli-arrtime  = lv_arrtime.
              gs_spfli-period   = lv_period.
              gs_SPFLI-light    = lv_LIGHT.

              MODIFY gt_spfli FROM gs_spfli INDEX ls_mod_cells-row_id.
          ENDCASE.
        ENDLOOP.
      ENDMETHOD.


   METHOD on_data_changed_finish.

    DATA : ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.

    LOOP AT et_good_cells INTO ls_mod_cells.

    PERFORM modify_check USING ls_mod_cells.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
