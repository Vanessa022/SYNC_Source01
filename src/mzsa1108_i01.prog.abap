*&---------------------------------------------------------------------*
*& Include          MZSA1108_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.

    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.

    WHEN 'ENTER'.
      "Get Emp Name
      PERFORM get_name USING zssa0073-pernr
                       CHANGING zssa0073-ename.

   ENDCASE.
ENDMODULE.
