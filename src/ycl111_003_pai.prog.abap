*&---------------------------------------------------------------------*
*& Include          YCL111_002_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN 'CANC'.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
      ok_code = save_ok.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SEARCH'.
      PERFORM select_data.
      PERFORM set_alv_layout_0100.
      PERFORM set_alv_fcat_0100.
      PERFORM display_alv_0100.

    WHEN OTHERS.
      ok_code = save_ok.

  ENDCASE.

  CLEAR save_ok.

ENDMODULE.
