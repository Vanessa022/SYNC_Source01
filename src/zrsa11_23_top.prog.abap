*&---------------------------------------------------------------------*
*& Include ZRSA11_23_TOP                            - Report ZRSA11_23
*&---------------------------------------------------------------------*
REPORT ZRSA11_23.


"Schedule Date Info
DATA: gt_info TYPE TABLE OF zsinfo00,
      gs_info LIKE LINE OF gt_info.

PARAMETERS: pa_car TYPE sbook-carrid DEFAULT 'AA',
            pa_con TYPE sbook-connid DEFAULT '0017'.
