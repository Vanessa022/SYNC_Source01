*&---------------------------------------------------------------------*
*& Include          MZSA1150_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code. "sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SEARCH'.
      "Get Meal & Vendor Info.
      PERFORM get_info.


    WHEN 'ENTER'.
      "Get Meal & Vendor Info.
      PERFORM get_info.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
   ENDCASE.
ENDMODULE.
