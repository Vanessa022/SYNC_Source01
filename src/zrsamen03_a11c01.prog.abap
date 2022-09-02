*&---------------------------------------------------------------------*
*& Include          ZRSAMAR02C01
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_toolbar_high FOR EVENT toolbar
        OF cl_gui_alv_grid
        IMPORTING e_object.
 ENDCLASS.

*      on_user_command FOR EVENT user_command
*        OF cl_gui_alv_grid
*        IMPORTING e_ucomm.

*ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_toolbar_high.
    DATA: ls_button TYPE stb_button.
    ls_button-function = 'SELECT'.
    ls_button-butn_type = '0'.
    ls_button-text = 'SELECT ALL'.
    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.

    CLEAR ls_button.
    ls_button-function = 'DESELECT'.
    ls_button-butn_type = '0'.
    ls_button-text = 'DESELECT ALL'.
    APPEND ls_button TO e_object->mt_toolbar.
  ENDMETHOD.
ENDCLASS.

*  METHOD on_user_command.
*    CASE e_ucomm.
*      WHEN 'DESSELECT'.
*        DATA: lt_rows TYPE lvc_t_rows.
*        CALL METHOD go_alv_grid_high->set_selected_rows
*          EXPORTING
*            it_index_rows = lt_rows.
*    ENDCASE.
*  ENDMETHOD.

*ENDCLASS.
