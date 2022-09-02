*&---------------------------------------------------------------------*
*& Report ZC1R110009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110009 MESSAGE-ID zmcsa11.

TABLES: sflight, sbook.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS      : pa_car   TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS  : so_con   FOR  sflight-connid OBLIGATORY.
  PARAMETERS      : pa_plnty TYPE sflight-planetype
                    AS LISTBOX VISIBLE LENGTH 15.
  SELECT-OPTIONS  : so_bkid  FOR  sbook-bookid.

SELECTION-SCREEN END OF BLOCK b1.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_car.
*  PERFORM f4_carrid.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bkid-low.


START-OF-SELECTION.

  DATA : BEGIN OF gs_itab1,
           carrid    TYPE sflight-carrid,
           connid    TYPE sflight-connid,
           fldate    TYPE sflight-fldate,
           planetype TYPE sflight-planetype,
           currency  TYPE sflight-currency,
           bookid    TYPE sbook-bookid,
           customid  TYPE sbook-customid,
           custtype  TYPE sbook-custtype,
           class     TYPE sbook-class,
           agencynum TYPE sbook-agencynum,
         END OF gs_itab1,

         gt_itab1 LIKE TABLE OF gs_itab1,

         BEGIN OF gs_itab2,
           carrid    TYPE sflight-carrid,
           connid    TYPE sflight-connid,
           fldate    TYPE sflight-fldate,
           bookid    TYPE sbook-bookid,
           customid  TYPE sbook-customid,
           custtype  TYPE sbook-custtype,
           agencynum TYPE sbook-agencynum,
         END OF gs_itab2,

         gt_itab2 LIKE TABLE OF gs_itab2,
         gv_tabix TYPE sy-tabix.

  REFRESH: gt_itab1, gt_itab2.

  "Inner Join
  SELECT a~carrid a~connid   a~fldate   a~planetype a~currency
         b~bookid b~customid b~custtype b~agencynum b~class
    INTO CORRESPONDING FIELDS OF TABLE gt_itab1
    FROM sflight AS a
    INNER JOIN sbook AS b
      ON a~carrid    = b~carrid
     AND a~connid    = b~connid
     AND a~fldate    = b~fldate
   WHERE a~carrid    = pa_car
     AND a~connid   IN so_con
     AND a~planetype = pa_plnty
     AND b~bookid   IN so_bkid.


  IF sy-subrc NE 0.
    MESSAGE i001.
    LEAVE LIST-PROCESSING.
  ENDIF.


  LOOP AT gt_itab1 INTO gs_itab1.

    CASE gs_itab1-custtype.
      WHEN 'B'.
        MOVE-CORRESPONDING gs_itab1 TO gs_itab2.      "tab1 에 있는 field 중에 이름이 같은걸 자동으로 옮겨줘라.

        APPEND gs_itab2 TO gt_itab2.
        CLEAR  gs_itab2.
    ENDCASE.

  ENDLOOP.

  SORT gt_itab2 BY carrid connid fldate. "순서는 반드시 맞춰줘야한다!!!!
  DELETE ADJACENT DUPLICATES FROM gt_itab2 COMPARING carrid connid fldate.

  IF gt_itab2 IS NOT INITIAL.
    cl_demo_output=>display( gt_itab2 ).
  ELSE.
    MESSAGE s001.
  ENDIF.
*&---------------------------------------------------------------------*
*& Form f4_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM f4_carrid .
*
*  DATA: BEGIN OF ls_carrid,
*          carrid   TYPE scarr-carrid,
*          carrname TYPE scarr-carrname,
*          currcode TYPE scarr-currcode,
*          url      TYPE scarr-url,
*        END OF ls_carrid,
*
*        lt_carrid LIKE TABLE OF ls_carrid.
*
*  REFRESH lt_carrid.
*
*  SELECT carrid carrname currcode url
*    FROM scarr
*    INTO CORRESPONDING FIELDS OF TABLE lt_carrid.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield     = 'CARRID'      "선택한 화면으로 세팅한 ITAB의 필드ID.
*      dynpprog     = 'sy-repid'
*      dynpnr       = 'sy-dynnr'
*      dynprofield  = 'PA_CAR'      "서치헬프 화면에서 선택한 데이터가 세팅될 화면의 필드ID.
**     WINDOW_TITLE = TEXT-t02
*      window_title = 'Airline List'
*      value_org    = '5'
*      display      = 'X'           "선택된 데이터가 세팅될 화면의 필드에 세팅 되는 것 막음.
*    TABLES
*      value_tab    = lt_carrid.
*
*  .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*
*
*ENDFORM.


DATA: BEGIN OF ls_scarr,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
          currcode TYPE scarr-currcode,
          url      TYPE scarr-url,
      END OF ls_scarr,
      lt_scarr LIKE TABLE OF ls_scarr.

   SELECT carrid carrname url
     FROM scarr
     INTO CORRESPONDING FIELDS OF TABLE lt_scarr.


   "New Syntax.
   SELECT carrid, carrname, url
     FROM scarr
     INTO TABLE @DATA(lt_scarr2).

*   READ TABLE lt_scarr2 INTO DATA(ls_scarr2) WITH KEY carrid = 'AA'.
   "선언 하면서 바로 실행 가능한 신문법. 모두 실행 가능한 것은 아니고 높은 버전 or s4hana 에서만 가능.

   LOOP AT lt_scarr2 INTO DATA(ls_scarr2).
   ENDLOOP.
*==========================================================================

   DATA: lv_carrid TYPE scarr-carrid,
         lv_carrname TYPE scarr-carrname.

   SELECT SINGLE carrid carrname
     INTO (lv_carrid, lv_carrname)
     FROM scarr
    WHERE carrid = 'AA'.

     "New Syntax.
   SELECT SINGLE carrid, carrname
     INTO (@DATA(lv_carrid2), @DATA(lv_carrname2))
     FROM scarr
    WHERE carrid = @pa_car. "'AA'.

*========================================================================

DATA: BEGIN OF ls_scarr3,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
          url      TYPE scarr-url,
      END OF ls_scarr3.

ls_scarr3-carrid      = 'AA'.
ls_scarr3-carrname    = 'America Airnline'.
ls_scarr3-url         = 'www.aa.com'.

ls_scarr3-carrid = 'KA'.

" New Syntax.
ls_scarr3 = VALUE #( carrid      = 'AA'
                     carrname    = 'America Airnline'
                     url         = 'www.aa.com' ).

ls_scarr3 = VALUE #( carrid = 'KA' ). "기술되지 않은 필드들은 모두 clear된다.

ls_scarr3 = VALUE #( BASE ls_scarr3   "-> 기술되지 않은 필드는 모두 유지시켜 준다.
                     carrid = 'KA' ).


*========================================================================

DATA: BEGIN OF ls_scarr4,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
          url      TYPE scarr-url,
      END OF ls_scarr4,

      lt_scarr4 LIKE TABLE OF ls_scarr4.

ls_scarr4-carrid      = 'AA'.
ls_scarr4-carrname    = 'America Airnline'.
ls_scarr4-url         = 'www.aa.com'.

APPEND ls_scarr4 TO lt_scarr4.

ls_scarr4-carrid      = 'KA'.
ls_scarr4-carrname    = 'Korean Airnline'.
ls_scarr4-url         = 'www.Ka.com'.

APPEND ls_scarr4 TO lt_scarr4.

*New Syntax.
REFRESH lt_scarr4.

lt_scarr4 = VALUE #(  "--> Work Area 필요 없이 데이터 append 가능.
                      ( carrid = 'AA'
                        carrname = 'American Airline'
                        url      = 'www.aa.com'
                       )
                       ( carrid = 'KA'
                        carrname = 'Korean Airline'
                        url      = 'www.ka.com'
                       )
                    ).

lt_scarr4 = VALUE #(  "--> 기존 itab의 row 모두 refresh 되고 지금 추가한 것만 남음.
                      ( carrid = 'LH'
                        carrname = 'Luft Hansa'
                        url      = 'www.lh.com'
                       )
                    ).

lt_scarr4 = VALUE #(  BASE lt_scarr4 "--> 기존 itab의 row 모두 유지시킴.
                      ( carrid = 'LH'
                        carrname = 'Luft Hansa'
                        url      = 'www.lh.com'
                       )
                    ).

*LOOP AT itab INTO wa.
*
*  lt_scarr4 = VALUE #( BASE lt_scarr4
*                       ( carrid   = wa-carrid
*                         carrname = wa-carrname
*                         url      = wa-url
*                        )
*                      ).
*ENDLOOP.

*========================================================================
MOVE-CORRESPONDING LS_SCARR3 TO LS_SCARR4.

" New Syntax.
ls_scarr4 = CORRESPONDING #( ls_scarr3 ).



*========================================================================
*ITAB의 데이터 이동 문법.
*========================================================================

gt_color = lt_color. "둘다 같은 구조의 itab 이어야 함: 기존데이터 사라짐.
gt_color[] = lt_color[]. "둘다 같은 구조의 itab 이어야 함:
"둘 다 같은 구조의 itab이면서 기존 데이터 밑으로 append.
APPEND LINES OF lt_color TO gt_color.

* 같필드ID에 대해서만 데이터 이동: 기존 데이터 사라짐.
MOVE-CORRESPONDING lt_color TO gt_color.

*같은필드 ID에 대해서만 데이터 이동: 기존 데이터 밑으로 append 됨.
MOVE-CORRESPONDING lt_color TO gt_color KEEPING TARGET LINES.


*========================================================================
*DB Table과 ITAB의 JOIN 방법.
*========================================================================
