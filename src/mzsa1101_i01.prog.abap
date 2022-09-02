*&---------------------------------------------------------------------*
*& Include          MZSA1101_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.  " 떠나세요 / 이전 화면으로 가세요
*      SET SCREEN 0.
*      LEAVE SCREEN. " 이 두개가 합쳐진 것이 위의 명령문.
    WHEN 'SEARCH'.
*      CLEAR zssa1131.
*      MESSAGE i000(zmcsa11) WITH sy-ucomm.  "i 는 팝업메세지로 뜬다
*      MESSAGE s000(zmcsa11) WITH sy-ucomm.  "s 는 왼쪽 하단에 메세지

*      "Select Single
*       SELECT SINGLE *
*        FROM ztsa0001 "Emp Table
*        INTO CORRESPONDING FIELDS OF zssa1131 " structure variable
*        WHERE pernr = gv_pernr.
*
    " Get Data
    PERFORM get_data USING gv_pernr
                     CHANGING zssa1131.

  ENDCASE.
ENDMODULE.
