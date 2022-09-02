*&---------------------------------------------------------------------*
*& Include          MZSA1103_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'SEARCH'.
      CALL SCREEN 200.
      MESSAGE i000(zmca11) with 'CALL'.
      PERFORM get_airline_name USING gv_carrid
                               CHANGING gv_carrname.
*      SET SCREEN 200.
*      LEAVE SCREEN.
   ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
*      SET SCREEN 100.
*      MESSAGE i100(zmcsa11) WITH 'BACK'.
*      LEAVE SCREEN.
*      CALL SCREEN 100.
       LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
