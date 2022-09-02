*&---------------------------------------------------------------------*
*& Report ZC1R110006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110006 MESSAGE-ID zmcsa11.

DATA: BEGIN OF gs_data,
        matnr TYPE mara-matnr,
        maktx TYPE makt-maktx,
        mtart TYPE mara-mtart,
        mtbez TYPE t134t-mtbez,
        mbrsh TYPE mara-mbrsh,
        mbbez TYPE t137t-mbbez,
        tragr TYPE mara-tragr,
        vtext TYPE ttgrt-vtext,
      END OF gs_data,

      gt_data  LIKE TABLE OF gs_data,

      gs_t134t TYPE t134t,
      gt_t134t LIKE TABLE OF gs_t134t,

      gs_t137t TYPE t137t,
      gt_t137t LIKE TABLE OF gs_t137t,

      gs_ttgrt TYPE ttgrt,
      gt_ttgrt LIKE TABLE OF gs_ttgrt,

      lv_tabix TYPE sy-tabix.


"Inner Join
SELECT a~matnr b~maktx a~mtart a~mbrsh a~tragr
  FROM mara AS a
 INNER JOIN makt AS b
    ON a~matnr = b~matnr
  INTO CORRESPONDING FIELDS OF TABLE gt_data
 WHERE spras = sy-langu.

"mtbez mtart
SELECT mtbez mtart
  FROM t134t
  INTO CORRESPONDING FIELDS OF TABLE gt_t134t
  WHERE spras = sy-langu.

"mbbez mbrsh
SELECT mbbez mbrsh
  FROM t137t
  INTO CORRESPONDING FIELDS OF TABLE gt_t137t
  WHERE spras = sy-langu.

"vtext tragr
SELECT vtext tragr
  FROM ttgrt
  INTO CORRESPONDING FIELDS OF TABLE gt_ttgrt
  WHERE spras = sy-langu.


LOOP AT gt_data INTO gs_data.

lv_tabix = sy-tabix.


 READ TABLE gt_t134t INTO gs_t134t WITH KEY mtart = gs_data-mtart.
 READ TABLE gt_t137t INTO gs_t137t WITH KEY mbrsh = gs_data-mbrsh.
 READ TABLE gt_ttgrt INTO gs_ttgrt WITH KEY tragr = gs_data-tragr.
   IF sy-subrc = 0.

     gs_data-mtart = gs_t134t-mtart.
     gs_data-mbrsh = gs_t137t-mbrsh.
     gs_data-tragr = gs_ttgrt-tragr.

     MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mtbez mbrsh tragr.
   ENDIF.

ENDLOOP.


cl_demo_output=>display_data( gt_data ).
