*&---------------------------------------------------------------------*
*& Report YCL111_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ycl111_001.

INCLUDE ycl111_001_TOP.                               "TOP              - 전역변수 선언
INCLUDE ycl111_001_CLS.                               "Local Class      - ALV 관련 선언.
INCLUDE ycl111_001_SCR.                               "Selection Screen - 검색화면
INCLUDE ycl111_001_PBO.                               "PBO              - Process Before Output
INCLUDE ycl111_001_PAI.                               "PAI              - Process After Input
INCLUDE ycl111_001_F01.                               "Subroutines


INITIALIZATION.
  "프로그램 실행 시 가장 처음에 1회만 수행되는 이벤트 구간
  Textt01 = '검색조건'.


AT SELECTION-SCREEN OUTPUT.
  "검색화면에서 화면이 출력되기 직전에 수행되는 구간
  " 주용도는 검색화면에 대한 제어 (측정필드 숨김 또는 읽기전용)

AT SELECTION-SCREEN.
  "검색화면에서 사용자가 특정 이벤틀를 발생시켰을 때 수행되는 구간
  "상단에 Function key 이벤트, 특정필드의 클릭, 엔터 등의 이벤트에서
  "입력값에 대한 점검, 실행 권한 점검

START-OF-SELECTION.
  "검색화면에서 실행버튼 눌렀을 때 수행되는 구간
  "데이터 조회가 주 용도

 PERFORM select_data.

End-of-SELECTION.
  "START-OF-SELECTION 이 끝나고 실행되는 구간
  "데이터 출력이 주 용도

IF gt_scarr[] IS INITIAL.
  MESSAGE '데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.
  "프로그램을 계속 이어서 진행되도록 만드는 타입 :
  " S( 하단에 메세지 출력하면서 계속)
  " I(팝업팡을 출력하면서 일시정지)

  "프로그램을 중단 시키는 타입 :
  " W, E, X
ELSE.
  CALL SCREEN 0100.
ENDIF.
