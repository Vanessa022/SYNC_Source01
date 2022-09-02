*&---------------------------------------------------------------------*
*& Report ZC1R110007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110007 MESSAGE-ID zmcsa11.

*DATA : gs_sbus TYPE sbuspart,
*       gt_sbus TYPE TABLE OF sbuspart.
*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
*
*  PARAMETERS pa_bus TYPE sbuspart-buspartnum OBLIGATORY.
*  SELECT-OPTIONS so_con FOR gs_sbus-contact NO INTERVALS.    "추가 값(high) 입력 불가.
*
*  PARAMETERS gv_1 RADIOBUTTON GROUP gr1 DEFAULT 'X'.
*  PARAMETERS gv_2 RADIOBUTTON GROUP gr1.
*
*SELECTION-SCREEN END OF BLOCK b1.
*
*IF gv_1 = 'X'.
*
*  SELECT buspartnum contact contphono buspatyp
*    FROM  sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_sbus
*    WHERE buspatyp = 'TA'.
*
*  cl_demo_output=>display_data( gt_sbus ).
*
*ELSEIF gv_2 = 'X'.
*
*  SELECT buspartnum contact contphono buspatyp
*    FROM  sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_sbus
*    WHERE buspatyp = 'FC'.
*
*  cl_demo_output=>display_data( gt_sbus ).
*ENDIF.




* -- SOLUTIONS --*

TABLES sbuspart.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS      : pa_num  TYPE sbuspart-buspartnum OBLIGATORY.
  SELECT-OPTIONS  : so_cont FOR sbuspart-contact     NO INTERVALS.

  SELECTION-SCREEN ULINE.   " Underline.

  PARAMETERS: pa_ta RADIOBUTTON GROUP rb1 DEFAULT 'X',
              pa_fc RADIOBUTTON GROUP rb1.

SELECTION-SCREEN END OF BLOCK b1.

DATA: gt_data TYPE TABLE OF sbuspart,
      gv_type TYPE sbuspart-buspatyp.

REFRESH gt_data.

*IF pa_ta IS NOT INITIAL.
*IF pa_ta NE space.
*IF pa_ta EQ 'X'.
*IF pa_ta = 'X'.
* = 전부 같은 뜻.

*IF pa_ta = 'X'.
*SELECT buspartnum contact contphono buspatyp
*  FROM sbuspart
*  INTO CORRESPONDING FIELDS OF TABLE gt_data
* WHERE buspartnum = pa_num
*   AND contact   IN so_cont
*   AND buspatyp   = 'TA'.
*
*ELSEIF pa_fc = 'X'.
*  SELECT buspartnum contact contphono buspatyp
*    FROM  sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_data
*   WHERE buspartnum = pa_num
*    AND contact     IN so_cont
*    AND buspatyp    = 'FC'.
*ENDIF.

*CASE 'X'.
*  WHEN pa_ta.
*    SELECT buspartnum contact contphono buspatyp
*      FROM sbuspart
*      INTO CORRESPONDING FIELDS OF TABLE gt_data
*     WHERE buspartnum = pa_num
*       AND contact   IN so_cont
*       AND buspatyp   = 'TA'.
*
*   WHEN pa_fc.
*      SELECT buspartnum contact contphono buspatyp
*        FROM  sbuspart
*        INTO CORRESPONDING FIELDS OF TABLE gt_data
*       WHERE buspartnum = pa_num
*        AND contact     IN so_cont
*        AND buspatyp    = 'FC'.
*ENDCASE.

CASE 'X'.
  WHEN pa_ta.
    gv_type = 'TA'.
  WHEN pa_fc.
    gv_type = 'FC'.
ENDCASE.

SELECT buspartnum contact contphono buspatyp
      FROM sbuspart
      INTO CORRESPONDING FIELDS OF TABLE gt_data
     WHERE buspartnum = pa_num
       AND contact   IN so_cont
       AND buspatyp   = gv_type.    "변수로 처리하면 한방에 쓸 수 있다!
