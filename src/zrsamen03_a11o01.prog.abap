*&---------------------------------------------------------------------*
*& Include          ZRSAMAR02O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER1 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE  create_and_transfer1 OUTPUT.
  IF go_container_high IS INITIAL.
    CREATE OBJECT go_container_high
      EXPORTING
        container_name = 'MY_CONTROL_AREA_HIGH'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_grid_high
      EXPORTING
        i_parent = go_container_high
      EXCEPTIONS
        OTHERS   = 5.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM set_fcat_high.
    PERFORM set_layout_high.


    SET HANDLER lcl_handler=>on_toolbar_high for go_alv_grid_high.

    CALL METHOD go_alv_grid_high->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SFLIGHT'
        is_layout        = gs_layout_high
      CHANGING
        it_outtab        = gt_sflight_high
        it_fieldcatalog  = gt_fcat_high
      EXCEPTIONS
        OTHERS           = 4.
  ELSE.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    CALL METHOD go_alv_grid_high->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER2 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer2 OUTPUT.
  IF go_container_low IS INITIAL.
    CREATE OBJECT go_container_low
      EXPORTING
        container_name = 'MY_CONTROL_AREA_LOW'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_grid_low
      EXPORTING
        i_parent = go_container_low
      EXCEPTIONS
        OTHERS   = 5.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM set_fcat_low.
    PERFORM set_layout_low.

    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct_low.

    CALL METHOD go_alv_grid_low->set_table_for_first_display
      EXPORTING
        i_structure_name     = 'SFLIGHT'
        is_layout            = gs_layout_low
        it_toolbar_excluding = gt_exct_low
      CHANGING
        it_outtab            = gt_sflight_low
        it_fieldcatalog      = gt_fcat_low
      EXCEPTIONS
        OTHERS               = 4.
  ELSE.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv_grid_low->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
  ENDIF.
ENDMODULE.
