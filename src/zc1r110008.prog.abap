*&---------------------------------------------------------------------*
*& Report ZC1R110008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110008 MESSAGE-ID zmcsa11.

*TABLES sbook.
*
*DATA : BEGIN OF gs_sbook,
*         carrid   TYPE sbook-carrid,
*         connid   TYPE sbook-connid,
*         fldate   TYPE sbook-fldate,
*         bookid   TYPE sbook-bookid,
*         customid TYPE sbook-customid,
*         custtype TYPE sbook-custtype,
*         invoice  TYPE sbook-invoice,
*         class    TYPE sbook-class,
*       END OF gs_sbook,
*
*       gt_sbook LIKE TABLE OF gs_sbook,
*       lv_tabix TYPE sy-tabix.
*
*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
*
*  PARAMETERS      pa_car    TYPE sbook-carrid   DEFAULT 'AA' OBLIGATORY.
*  SELECT-OPTIONS  so_con    FOR  sbook-connid   OBLIGATORY.
*  PARAMETERS      pa_cust   TYPE sbook-custtype OBLIGATORY
*                  AS LISTBOX VISIBLE LENGTH 10.
*  SELECT-OPTIONS: so_fld    FOR  sbook-fldate   DEFAULT sy-datum,
*                  so_bkid   FOR  sbook-bookid,
*                  so_cusid  FOR  sbook-customid NO INTERVALS.
*
*SELECTION-SCREEN END OF BLOCK b1.
*
*REFRESH gt_sbook.
*
*SELECT carrid connid fldate bookid
*       customid custtype invoice class
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
* WHERE carrid    = pa_car
*   AND connid   IN so_con
*   AND custtype  = pa_cust
*   AND fldate   IN so_fld
*   AND bookid   IN so_bkid
*   AND customid IN so_cusid.
*
*IF sy-subrc NE 0.
*  MESSAGE s001.
*  LEAVE LIST-PROCESSING.    " = STOP.
*ENDIF.
*
*LOOP AT gt_sbook INTO gs_sbook.
*
*  lv_tabix = sy-tabix.
*
*  CASE gs_sbook-invoice.
*    WHEN 'X'.
*      gs_sbook-class = 'F'.
*  ENDCASE.
*
*  MODIFY gt_sbook FROM gs_sbook
*   INDEX lv_tabix TRANSPORTING class.
*
*ENDLOOP.
*
*cl_demo_output=>display_data( gt_SBOOK ).


*-- Solutions --*

TABLES: sbook.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS      : pa_carr  TYPE sbook-carrid OBLIGATORY DEFAULT 'AA'.
  SELECT-OPTIONS  : so_conn  FOR  sbook-connid OBLIGATORY.
  PARAMETERS      : pa_cutyp TYPE sbook-custtype OBLIGATORY
                    AS LISTBOX VISIBLE LENGTH 20 DEFAULT 'P'.

  SELECT-OPTIONS  : so_fldt   FOR  sbook-fldate DEFAULT sy-datum,
                    so_bkid  FOR  sbook-bookid,
                    so_cusid FOR  sbook-customid NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b1.

DATA: BEGIN OF gs_data,
         carrid   TYPE sbook-carrid,
         connid   TYPE sbook-connid,
         fldate   TYPE sbook-fldate,
         bookid   TYPE sbook-bookid,
         customid TYPE sbook-customid,
         custtype TYPE sbook-custtype,
         invoice  TYPE sbook-invoice,
         class    TYPE sbook-class,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data,
       gv_tabix TYPE sy-tabix.

SELECT carrid connid fldate bookid
       customid custtype invoice class
  FROM sbook
  INTO CORRESPONDING FIELDS OF TABLE gt_data
 WHERE carrid    = pa_carr
   AND connid   IN so_conn
   AND custtype  = pa_cutyp
   AND fldate   IN so_fldt
   AND bookid   IN so_bkid
   AND customid IN so_cusid.

IF sy-subrc NE 0.
  MESSAGE s001.
  LEAVE LIST-PROCESSING.    " = STOP.
ENDIF.

LOOP AT gt_data INTO gs_data.

  gv_tabix = sy-tabix.

  CASE gs_data-invoice.
    when 'X'.
      gs_data-class = 'F'.

      MODIFY gt_data FROM gs_data INDEX gv_tabix
      TRANSPORTING class.
  ENDCASE.

ENDLOOP.

cl_demo_output=>display_data( gt_data ).
