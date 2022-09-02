*&---------------------------------------------------------------------*
*& Include          MZSA1104_I01
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
      LEAVE SCREEN.

     WHEN 'Search'.
       CLEAR zssa1131.
        SELECT SINGLE *
         FROM ztsa1101  "emp Table
         INTO CORRESPONDING FIELDS OF zssa1131
         WHERE pernr = gv_pernr.

  ENDCASE.
ENDMODULE.
