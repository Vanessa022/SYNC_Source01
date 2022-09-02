*&---------------------------------------------------------------------*
*& Report ZRSA11_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa11_23_top                           .    " Global Data

* INCLUDE ZRSA11_23_O01                           .  " PBO-Modules
* INCLUDE ZRSA11_23_I01                           .  " PAI-Modules
 INCLUDE zrsa11_23_f01                           .  " FORM-Routines

* Event
* INITIALIZATION. "Runtime 에 딱 한번 실행
*  SELECT SINGLE carrid connid
*    FROM spfli
*    INTO ( pa_car, pa_con ).

INITIALIZATION. " type이 '1' 일때만 사용 가능 ( executable program )
  IF sy-uname = 'KD-A-11'.
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.

 AT SELECTION-SCREEN OUTPUT. "PBO

 AT SELECTION-SCREEN. "PAI
   IF pa_con IS INITIAL.
     "E/W
     MESSAGE w016(pn) WITH 'Check'.
     " I
*     MESSAGE s016(pn) WITH 'Check'.
*     STOP. "약간 비정상적인 액션
   ENDIF.

 START-OF-SELECTION.

  " Get Info List
  PERFORM get_info.
  WRITE 'Test'.
 IF gt_info IS INITIAL.
   "s, I
   MESSAGE w016(pn) WITH 'Data is not found'. "& 기호가 뒤에 '콤마' 안에 있는 내용을 받아주는 것,
 RETURN.
 ENDIF.

  cl_demo_output=>display_data( gt_info ).

*   IF gt_info IS NOT INITIAL.
*   cl_demo_output=>display_data( gt_info ).
*   ELSE.
*
* ENDIF.
