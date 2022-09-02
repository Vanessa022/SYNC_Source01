*&---------------------------------------------------------------------*
*& Report YRSA11_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yrsa11_01.

DATA : gs_emp TYPE ztsa1101,  "ztsa1101
       gt_emp LIKE TABLE OF gs_emp.
       "위에서 선언한 structure를 참조하는 internal table 선언.


DATA: BEGIN OF gs_mara,
        matnr TYPE mara-matnr,
        werks TYPE marc-werks,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
        ekgrp TYPE marc-ekgrp,
        pstat TYPE marc-pstat.
DATA: END OF gs_mara.

DATA: gt_mara LIKE TABLE OF gs_mara.
