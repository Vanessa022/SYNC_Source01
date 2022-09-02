*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_CL1_A11_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alv_cl1_a11_1.

TABLES: ztsbook_a11.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR ztsbook_a11-carrid OBLIGATORY MEMORY ID car,
                  so_con FOR ztsbook_a11-connid            MEMORY ID con,
                  so_fld FOR ztsbook_a11-fldate,
                  so_cus FOR ztsbook_a11-customid.

  SELECTION-SCREEN SKIP.

  PARAMETERS: pa_edit AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b1.

TYPES: BEGIN OF gty_book.
         INCLUDE TYPE ztsbook_a11.

TYPES: END OF gty_book.


DATA: gt_sbook TYPE TABLE OF gty_book,
      gs_sbook TYPE          gty_book.

DATA: ok_code TYPE sy-ucomm.




*-- ALV 변수 --*

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.



START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.






*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname sy-langu.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

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

  DATA: gt_temp TYPE TABLE OF gty_book.

  SELECT *
    FROM ztsbook_a11
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
   WHERE carrid   IN so_car
     AND connid   IN so_con
     AND fldate   IN so_fld
     AND customid IN so_cus.

ENDFORM.


*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.

*-- Container --*
  CREATE OBJECT go_container
    EXPORTING
      container_name = 'MY_CONTROL_AREA'.
  IF sy-subrc = 0.


*-- ALV --*
    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_container.
    IF sy-subrc = 0.

*-- ALV에 속한 method --*
    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
*        i_buffer_active               =
*        i_bypassing_buffer            =
*        i_consistency_check           =
        i_structure_name              = 'ZTSBOOK_A11'
*        is_variant                    =
*        i_save                        =
*        i_default                     = 'X'
*        is_layout                     =
*        is_print                      =
*        it_special_groups             =
*        it_toolbar_excluding          =
*        it_hyperlink                  =
*        it_alv_graphics               =
*        it_except_qinfo               =
*        ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_sbook
*        it_fieldcatalog               =
*        it_sort                       =
*        it_filter                     =
*      EXCEPTIONS
*        invalid_parameter_combination = 1
*        program_error                 = 2
*        too_many_lines                = 3
*        others                        = 4
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
    ENDIF.
  ENDIF.


ENDMODULE.
