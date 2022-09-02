*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_CL1_A11_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:

      on_doubleclick FOR EVENT
        double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      on_toolbar FOR EVENT
        toolbar OF cl_gui_alv_grid
        IMPORTING e_object,

      on_usercommand FOR EVENT
        user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_data_changed FOR EVENT
        data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      on_data_changed_finish FOR EVENT
        data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.

ENDCLASS.



CLASS lcl_handler IMPLEMENTATION.

  METHOD on_doubleclick.
    DATA: carrname TYPE scarr-carrname.

    CASE e_column-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_sbook INTO gs_sbook
             INDEX e_row-index.
        IF sy-subrc = 0.

          SELECT SINGLE carrname
            FROM scarr
            INTO carrname
            WHERE carrid = gs_sbook-carrid.

          IF sy-subrc = 0.
            MESSAGE i000(zt03_msg) WITH carrname.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.




  METHOD on_toolbar.
    DATA: wa_button TYPE stb_button.

    wa_button-butn_type = '3'.              "Separator.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    CLEAR: wa_button.
    wa_button-butn_type   = '0'.              "Normal Button.
    wa_button-function     = 'GOTOFL'.        "Flight connection - Call Transaction
    wa_button-icon        = ICON_Flight.
    wa_button-quickinfo  = 'Go to flight connection'.
    wa_button-text        = 'Flight'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.
  ENDMETHOD.





  METHOD on_usercommand.
    DATA: ls_col  TYPE lvc_s_col,
          ls_roid TYPE lvc_s_roid.


    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_col_id = ls_col
        es_row_no = ls_roid.

    CASE e_ucomm.
      WHEN 'GOTOFL'.
        READ TABLE gt_sbook INTO gs_sbook
        INDEX ls_roid-row_id.

        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid.
          SET PARAMETER ID 'CON' FIELD gs_sbook-connid.

          CALL TRANSACTION 'SAPBC405CAL'.
        ENDIF.
    ENDCASE.

  ENDMETHOD.



  METHOD on_data_changed.
    FIELD-SYMBOLS: <fs> LIKE gt_sbook.

    DATA: er_mod_cells TYPE lvc_s_modi,
          ls_ins_cells TYPE lvc_s_moce,
          ls_del_cells TYPE lvc_s_moce.

    LOOP AT er_data_changed->mt_good_cells INTO er_mod_cells.

      CASE  er_mod_cells-fieldname.
        WHEN 'CUSTOMID'.
          PERFORM customer_change_part USING er_data_changed
                                              er_mod_cells.

        WHEN 'CANCELLED'.
      ENDCASE.
    ENDLOOP.




*-- Insert Parts --*
    IF er_data_changed->mt_inserted_rows IS NOT INITIAL.

      ASSIGN er_data_changed->mp_mod_rows->* TO <fs>.
      IF sy-subrc = 0.
        APPEND LINES OF <fs> TO gt_sbook.
        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.

          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_cells-row_id.
          IF sy-subrc = 0.

            PERFORM insert_parts USING er_data_changed
                                          ls_ins_cells.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.



*-- Delete Parts --*
    IF er_data_changed->mt_deleted_rows IS NOT INITIAL.

      LOOP AT er_data_changed->mt_deleted_rows INTO ls_del_cells.

        READ TABLE gt_sbook INTO gs_sbook INDEX ls_del_cells-row_id.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING gs_sbook TO dw_sbook.
          APPEND dw_sbook TO dl_sbook.    "내가 지우려는 data가 dl_sbook에 쌓인다.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD on_data_changed_finish.
    DATA: ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.

    LOOP AT et_good_cells INTO ls_mod_cells.

      PERFORM modify_check USING ls_mod_cells.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
