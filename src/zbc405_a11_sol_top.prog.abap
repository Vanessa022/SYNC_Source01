*&---------------------------------------------------------------------*
*& Include ZBC405_A11_SOL_TOP                       - Report ZBC405_A11_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a11_sol.

TABLES: dv_flights.

DATA: gs_flight TYPE dv_flights.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
*PARAMETERS: p_car TYPE dv_flights-carrid
*                  MEMORY ID car OBLIGATORY
*                  DEFAULT 'LH' VALUE CHECK,
*
*            p_con TYPE s_conn_id
*                  MEMORY ID con OBLIGATORY.

SELECT-OPTIONS: s_car FOR dv_flights-carrid MEMORY ID car.
SELECT-OPTIONS: s_con FOR dv_flights-connid.
SELECT-OPTIONS: s_fldate FOR dv_flights-fldate NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP 2.

*PARAMETERS: p_str TYPE string LOWER CASE
*                  MODIF ID mod.

*PARAMETERS: p_chk AS CHECKBOX DEFAULT 'X'
*                  MODIF ID mod.

SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME TITLE TEXT-t02.
SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN COMMENT 2(5) TEXT-002.
    PARAMETERS: p_all RADIOBUTTON GROUP rd1. "그룹이름을 똑같이 주면  자동으로 생성.

    SELECTION-SCREEN COMMENT pos_low(8) TEXT-003.
    PARAMETERS: p_dom RADIOBUTTON GROUP rd1.

    SELECTION-SCREEN COMMENT pos_high(14) TEXT-004.
    PARAMETERS: p_int radiobutton group rd1 default 'X'.

SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK radio.


*LOOP AT SCREEN.
*  IF screen-group1 = 'MOD'.
*    " 스크린 아이디가 MOD인 필드는
*
*   screen-input = 0. "입력 못하게 해라.
*   screen-output = 1. "출력 가능하게 해라.
*   MODIFY SCREEN.
*  ENDIF.
*ENDLOOP.

*CASE 'X'.
*  WHEN p_rad1.
*
*  WHEN p_rad2.
*
*  WHEN p_rad3.
*
*ENDCASE.

*SET PARAMETER ID 'car' FIELD p_car. " car 메모리에 있는 값을 p_car 로 설정하라.
*get PARAMETER ID 'car' FIELD p_car. " car 메모리에 있는 값을 p_car 로 가져와라.
