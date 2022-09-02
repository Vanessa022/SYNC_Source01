*&---------------------------------------------------------------------*
*& Include          YCL111_002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form refresh_grid_0100
*&---------------------------------------------------------------------*
FORM refresh_grid_0100 .

  CHECK gr_alv IS BOUND.

  DATA: ls_stable TYPE lvc_s_stbl.
  ls_stable-row = abap_off.
  ls_stable-col = abap_on.

  CALL METHOD gr_alv->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = space    "space = 설정된 필터/정렬 정보 초기화, 'X' = 유지.
      "alv에 필터나 정렬을 걸어뒀을때 유지할까 or 정리할까(날릴까) 를 정한다.
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  gr_con = NEW cl_gui_custom_container(
    container_name          = 'MY_CONTAINER'
  ).

  gr_alv = NEW cl_gui_alv_grid(
    i_parent                = gr_con
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_scarr.

  RANGES lr_carrid  FOR scarr-carrid.      "헤더라인을 가지고있는 ITAB으로 선언된다.
  RANGES lr_carrname FOR scarr-carrname.

  IF  scarr-carrid   IS INITIAL AND
      scarr-carrname IS INITIAL.
    "ID와 이름 모두 공란인 경우

  ELSEIF
    scarr-carrid IS INITIAL.
    "이름은 공란이 아닌 경우
    lr_carrname-sign   = 'I'.
    lr_carrname-option = 'EQ'.
    lr_carrname-low    = scarr-carrname.
    APPEND lr_carrname.
    CLEAR  lr_carrname.

  ELSEIF
    scarr-carrname IS INITIAL.
    "ID는 공란이 아닌 경우
    lr_carrid-sign   = 'I'.   "I/E : Include / Exclude: 포함 / 제외
    lr_carrid-option = 'EQ'.
    lr_carrid-low    = scarr-carrid.
    APPEND lr_carrid.
    CLEAR  lr_carrid.

  ELSE.
    "ID와 이름이 둘다 공란이 아닌 경우
    "이름은 공란이 아닌 경우
    lr_carrname-sign = 'I'.
    lr_carrname-option = 'EQ'.      " eq = 같음
    lr_carrname-low = scarr-carrname.
    APPEND lr_carrname.
    CLEAR  lr_carrname.

    "ID 가 공란이 아닌 경우
    lr_carrid-sign = 'I'.     " I / E : Include / Exclude : 포함 / 제외
    lr_carrid-option = 'EQ'.
    lr_carrid-low = scarr-carrid.
    APPEND lr_carrid.
    CLEAR  lr_carrid.

  ENDIF.
*
*  SELECT *
*    FROM scarr
*   WHERE carrid   IN @lr_carrid
*     AND carrname IN @lr_carrname
*    INTO TABLE @gt_scarr.


  SELECT *
    FROM scarr
   WHERE carrid   IN @so_car
     AND carrname IN @so_carnm
    INTO TABLE @gt_scarr.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_layout_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  CLEAR gs_layout.
  gs_layout-zebra = 'X'.
  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_fcat_0100
*&---------------------------------------------------------------------*
FORM set_alv_fcat_0100 .

  DATA lt_fcat TYPE kkblo_t_fieldcat.

  REFRESH gt_fcat.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = sy-repid                 " Internal table declaration program
*     i_tabname              =                          " Name of table to be displayed
      i_strucname            = 'SCARR'
      i_inclname             = sy-repid
      i_bypassing_buffer     = 'X'                      " Ignore buffer while reading
      i_buffer_active        = space
    CHANGING
      ct_fieldcat            = lt_fcat                  " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.

  IF lt_fcat[] IS INITIAL.
    MESSAGE'ALV 필드 카탈로그 구성이 실패했습니다' TYPE 'E'.
  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        it_fieldcat_kkblo = lt_fcat
      IMPORTING
        et_fieldcat_lvc   = gt_fcat
      EXCEPTIONS
        it_data_missing   = 1
        OTHERS            = 2.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  CALL METHOD gr_alv->set_table_for_first_display
    EXPORTING
      is_layout                     = gs_layout            " Layout
    CHANGING
      it_outtab                     = gt_scarr[]           " Output Table
      it_fieldcatalog               = gt_fcat[]            " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                    " Wrong Parameter
      program_error                 = 2                    " Program Errors
      too_many_lines                = 3                    " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.


ENDFORM.
