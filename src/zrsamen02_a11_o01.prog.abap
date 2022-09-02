*&---------------------------------------------------------------------*
*& Include          ZRSAMEN02_A11_O01
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
*& Module CREATE_HIGH OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_high OUTPUT.
  IF go_container_high is INITIAL.
      CREATE OBJECT go_container_high
    EXPORTING
      container_name = 'MY_CONTROL_AREA_HIGH'.

   CREATE OBJECT go_alv_grid_high
     EXPORTING
       i_parent          = go_container_high.


   CALL METHOD go_alv_grid_high->set_table_for_first_display
     EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
       i_structure_name              = 'sflight'
*       is_variant                    =
*       i_save                        =
*       i_default                     = 'X'
*       is_layout                     =
*       is_print                      =
*       it_special_groups             =
*       it_toolbar_excluding          =
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
     CHANGING
       it_outtab = gt_sflight_high    "table 넣어줘야 한다.
*       it_fieldcatalog               =
*       it_sort                       =
*       it_filter                     =
*     EXCEPTIONS
*       invalid_parameter_combination = 1
*       program_error                 = 2
*       too_many_lines                = 3
*       others                        = 4
           .
   IF sy-subrc <> 0.
*    Implement suitable error handling here
  ENDIF.
   ENDIF.


ENDMODULE.
