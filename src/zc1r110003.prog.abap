*&---------------------------------------------------------------------*
*& Report ZC1R110003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110003 MESSAGE-ID ZMCSA11.


DATA: BEGIN OF gs_sflight,
        carrid      TYPE sflight-carrid,
        connid      TYPE sflight-connid,
        fldate      TYPE sflight-fldate,
        currency    TYPE sflight-currency,
        planetype   TYPE sflight-planetype,
        seatsocc_b  TYPE sflight-seatsocc_b.
DATA: END OF gs_sflight,
      gt_sflight LIKE TABLE OF gs_sflight,
      lv_tabix TYPE sy-tabix.

SELECT carrid connid fldate currency planetype seatsocc_b
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE gt_sflight
 WHERE currency   = 'USD'
   AND planetype  = '747-400'.

IF sy-subrc NE 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.    " = STOP.
  ENDIF.

  LOOP AT gt_sflight INTO gs_sflight.
    lv_tabix = sy-tabix.

    CASE gs_sflight-carrid.
      WHEN 'UA'.

        gs_sflight-seatsocc_b = gs_sflight-seatsocc_b + 5.

         MODIFY gt_sflight FROM gs_sflight INDEX lv_tabix
         TRANSPORTING seatsocc_b.
    ENDCASE.
   ENDLOOP.


cl_demo_output=>display_data( gt_sflight ).
