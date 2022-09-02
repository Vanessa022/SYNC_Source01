*&---------------------------------------------------------------------*
*& Report ZBC405_OM_A11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_om_a11. " 비행 CONNECTION TABLE 읽기.
TABLES: spfli.

SELECT-OPTIONS: so_car FOR spfli-carrid MEMORY ID car,
                so_con FOR spfli-connid MEMORY ID con.


DATA: gt_spfli TYPE TABLE OF spfli,
      gs_spfli TYPE spfli.

DATA: go_alv TYPE REF TO cl_salv_table. " main table.


START-OF-SELECTION.

  SELECT *
    FROM spfli
    INTO TABLE gt_spfli
    WHERE carrid in so_car
      AND connid in so_con.

  TRY.                                  "의도치 않은 덤프 방지용
  CALL METHOD cl_salv_table=>factory
    EXPORTING
       list_display   = 'X' "IF_SALV_C_BOOL_SAP=>FALSE   "Instance 생성해주는 것.
*      r_container    =
*      container_name =
    IMPORTING
      r_salv_table   = go_alv
    CHANGING
      t_table = gt_spfli.
    CATCH cx_salv_msg.
  ENDTRY.                                 "의도치 않은 덤프 방지용


  CALL METHOD go_alv->display.
