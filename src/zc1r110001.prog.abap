*&---------------------------------------------------------------------*
*& Report ZC1R110001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r110001.

DATA: gs_data TYPE ztsa1101,
      gt_data  TYPE TABLE OF ztsa1101.

DATA: BEGIN OF gs_data2.
        INCLUDE STRUCTURE ztsa1101.
DATA: END OF gs_data2,

      gt_data2 LIKE TABLE OF gs_data2.

" 위아래가 동일하다.


DATA: BEGIN OF gs_data2.
        INCLUDE STRUCTURE ztsa1101.
DATA: matnr TYPE mara-matnr,
      wekrs TYPE macr-wekrs,
      END OF gs_data2.

      gt_data2 LIKE TABLE OF gs_data2.

      "ztsa1101 데이터 전체 + mara 의 일부분 가져온 것.
