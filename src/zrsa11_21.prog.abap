*&---------------------------------------------------------------------*
*& Report ZRSA11_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_21.

TYPES: BEGIN OF gs_info,
         carrid     TYPE c LENGTH 3,
         carrname   TYPE scarr-carrname,
         connid     TYPE spfli-connid,
         countryfr  TYPE spfli-countryfr,
         countryto  TYPE spfli-countryto,
         atype, "TYPE c LENGTH 1
         atype_t TYPE c LENGTH 10,
       END OF gs_info.

* Connection Internal Table
DATA gt_info TYPE TABLE OF gs_info.

* Structure Variable
DATA gs_info LIKE LINE OF gt_info.
"type ts_info 를 사용해도 무방. LIKE LINE OF 는 gt_infp와 관련된 스트럭쳐 변수는 gs_info야 라고 정확하게 선언해 주는 것일 뿐.

"위 아래 방식 둘 다 사용 가능! JUST DIFF WAYS.
*DATA: gs_info TYPE ts_info,
*      gt_info LIKE TABLE OF gs_info.

PARAMETERS pa_car LIKE gs_info-carrid.

*PERFORM add_info USING 'AA'
*                       '0017'
*                       'US'
*                       'US'.
*PERFORM add_info USING 'AA' '0064' 'US' 'US'.
*
SELECT carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid = pa_car.

LOOP AT gt_info INTO gs_info.
  " Get atype( D, I )
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = 'D'.
  ELSE.
     gs_info-atype = 'I'.
  ENDIF.

  " Get Airline name (carrname)
 SELECT SINGLE carrname
   FROM SCARR
   INTO gs_info-carrname
   WHERE carrid = gs_info-carrid.

  MODIFY gt_info FROM gs_info TRANSPORTING carrname atype. "gs_info에 있는 atype 값만 바꿔주세요.
  CLEAR gs_info.
ENDLOOP.

SORT gt_info BY atype ASCENDING. "Ascending 은 생략가능.

cl_demo_output=>display_data( gt_info ).

*&---------------------------------------------------------------------*
*& Form add_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_info USING VALUE(p_carrid)
                    VALUE(p_connid)
                    VALUE(p_cfr)
                    VALUE(p_cto).
  DATA ls_info LIKE LINE OF gt_info.
  CLEAR ls_info.
  ls_info-carrid = p_carrid.
  ls_info-connid = p_connid.
  ls_info-countryfr = p_cfr.
  ls_info-countryto = p_cto.
  APPEND ls_info TO gt_info.
  CLEAR ls_info.
ENDFORM.
