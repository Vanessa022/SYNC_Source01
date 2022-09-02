*&---------------------------------------------------------------------*
*& Include ZRSA11_51_TOP                            - Report ZRSA11_51
*&---------------------------------------------------------------------*
REPORT ZRSA11_51.
TABLES: sflight.
*DATA scarr TYPE scarr.
"일반적 구조를 가지고 있는 strucutre type

PARAMETERS: pa_car TYPE scarr-carrid,
            pa_con TYPE spfli-connid.

SELECT-OPTIONS so_dat FOR sflight-fldate.
