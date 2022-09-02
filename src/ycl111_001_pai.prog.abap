*&---------------------------------------------------------------------*
*& Include          YCL111_001_PAI
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
      LEAVE PROGRAM.        "프로그램을 나가라.

    WHEN 'SAVE'.
      LEAVE TO SCREEN 0.    "이전화면으로 가라.

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
      LEAVE TO SCREEN 0.    "이전화면으로 가라.

    WHEN OTHERS.
      ok_code = save_ok.
  ENDCASE.

ENDMODULE.
