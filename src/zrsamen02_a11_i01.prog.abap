*&---------------------------------------------------------------------*
*& Include          ZRSAMEN02_A11_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      Leave to SCREEN 0.
  ENDCASE.
ENDMODULE.
