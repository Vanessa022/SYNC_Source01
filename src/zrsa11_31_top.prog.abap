*&---------------------------------------------------------------------*
*& Include ZRSA11_31_TOP                            - Report ZRSA11_31
*&---------------------------------------------------------------------*
REPORT ZRSA11_31.

" Employee List 선언
DATA: gs_emp TYPE zssa0004, "structure 변수 선언.
      gt_emp LIKE TABLE OF gs_emp.

" Selection Screen
PARAMETERS: pa_ent_b LIKE gs_emp-entdt,
            pa_ent_e LIKE gs_emp-entdt.
