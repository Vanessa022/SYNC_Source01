*&---------------------------------------------------------------------*
*& Include ZRSA11_24_TOP                            - Report ZRSA11_24
*&---------------------------------------------------------------------*
REPORT zrsa11_24.

DATA: BEGIN OF gs_info,
         carrid       TYPE sflight-carrid,
         carrname     TYPE scarr-carrname,
         connid       TYPE sflight-connid,
         cityfrom     TYPE spfli-cityfrom,
         cityto       TYPE spfli-cityto,
         fldate       TYPE sflight-fldate,
         price        TYPE sflight-price,
         currency     TYPE sflight-currency,
         seatsocc     TYPE sflight-seatsocc,
         seatsmax     TYPE sflight-seatsmax,
         seatremain   LIKE sflight-seatsocc,
         seatsocc_b   TYPE sflight-seatsocc_b,
         seatsmax_b   TYPE sflight-seatsmax_b,
         seatremain_b LIKE sflight-seatsocc_b,
         seatsocc_f   TYPE sflight-seatsocc_f,
         seatsmax_f   TYPE sflight-seatsmax_f,
         seatremain_f LIKE sflight-seatsocc_f,
       END OF gs_info.

DATA: gt_info LIKE TABLE OF gs_info.

PARAMETERS: pa_car TYPE sbook-carrid,
            pa_con1 TYPE sbook-connid,
            pa_con2 TYPE sbook-connid.
