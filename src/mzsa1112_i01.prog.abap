*&---------------------------------------------------------------------*
*& Include          MZSA1110_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code. "SY-UCOMM.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SEARCH'.
      "get Connection Info
      PERFORM get_conn_info USING zssa1180-carrid
                                  zssa1180-connid
                            CHANGING zssa1182.

      IF gv_subrc <> 0.
        MESSAGE i016(pn) WITH 'Data is not found'.
        RETURN.
      ENDIF.

    WHEN 'ENTER'.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
CASE sy-ucomm.  "그때그때 달라진다. 시스템변수 제어 X
  WHEN 'EXIT'.
    LEAVE PROGRAM.
  WHEN 'CANC'.
    LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.


" can use both sy-ucomm or ok_code.
      " ok_code 는 시스템 변수를 받아서 어느정도 내가 제어 가능.
