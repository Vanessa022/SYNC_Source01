*&---------------------------------------------------------------------*
*& Report ZC1R110002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110002 MESSAGE-ID zc226.

*DATA: gs_sbook TYPE sbook,
*      gt_sbook TYPE TABLE OF sbook.
*
*SELECT carrid connid fldate bookid customid custtype invoice class smoker
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
* WHERE CARRID = 'DL'
*   AND CUSTTYPE = 'P'
*   AND ORDER_DATE = '20201227'.
**cl_demo_output=>display_data( gt_sbook ).
*
*LOOP AT gt_sbook INTO gs_sbook.
*  IF gs_sbook-smoker ='X'.
*
*   IF gs_sbook-invoice = 'X'.
*
*      gs_sbook-class = 'F'.
*
*   ENDIF.
*
*  ENDIF.
*   MODIFY gt_sbook FROM gs_sbook.
*    ENDLOOP.
*
* cl_demo_output=>display_data( gt_sbook ).
*
*


*-- Solution --*

 DATA:   gs_sbook TYPE sbook,
         gt_sbook TYPE TABLE OF sbook,
         lv_tabix TYPE sy-tabix.

 CLEAR   gs_sbook.
 REFRESH gt_sbook.

SELECT carrid connid fldate bookid customid
       custtype invoice class smoker
  FROM sbook
  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
 WHERE carrid     = 'DL'
   AND custtype   = 'P'
   AND order_date = '20201227'.

  IF sy-subrc NE 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.    " = STOP.
  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    lv_tabix = sy-tabix.

    CASE gs_sbook-smoker.
      WHEN 'X'.

        CASE gs_sbook-invoice.
          WHEN 'X'.
            gs_sbook-class = 'F'.

            MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix
            TRANSPORTING class.
        ENDCASE.
    ENDCASE.

ENDLOOP.

cl_demo_output=>display_data( gt_sbook ).


* -- IF문은 가능한 CASE 문으로 사용하는것이 좋다 --*
*    IF gs_sbook-smoker  = 'X' AND
*       gs_sbook-invoice = 'X'.
*
*      gs_sbook-class = 'F'.
*
*      MODIFY gt_sbook FROM gs_sbook INDEX lv-tabix
*      TRANSPORTING class.   "다른건 건들이지 말고 class 데이터만 바꿔라.
*
*    ENDIF.
*  ENDLOOP.
