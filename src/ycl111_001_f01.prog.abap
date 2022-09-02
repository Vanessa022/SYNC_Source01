*&---------------------------------------------------------------------*
*& Include          YCL111_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_scarr.   "Internal Table 초기화

*  CLEAR gt_scarr[].   "headerline 이 있는 테이블은 헤더라인을 지움. but 없으면 internal table 초기화.
  "[] = 초기상태로 만든다

  SELECT *
    FROM scarr
   WHERE carrid   IN @so_car        "@ 쓰는 이유: 필드끼리 계산이 가능해진다.
     AND carrname IN @so_carnm      "+ 조건을 붙일 수 있다
    INTO TABLE @gt_scarr.          "@는 변수 앞에 붙인다 = 언제든 변할 수 있는 변수라는 것을 나타낸다.

  SORT gt_scarr BY carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT gr_con
    EXPORTING
      repid                       = sy-repid         " Report to Which This Docking Control is Linked
      dynnr                       = sy-dynnr         " Screen to Which This Docking Control is Linked
      EXTENSION                   = 2000             " Control Extension
    EXCEPTIONS
      cntl_error                  = 1                " Invalid Parent Control
      cntl_system_error           = 2                " System Error
      create_error                = 3                " Create Error
      lifetime_error              = 4                " Lifetime Error
      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      others                      = 6.

   CREATE OBJECT gr_split
     EXPORTING
       parent                  = gr_con             " Parent Container 어떤 컨테이너를 쪼갤거너ㅑ
       rows                    = 2                  " Number of Rows to be displayed 위아래로 몇개
       columns                 = 1                  " Number of Columns to be Displayed 양옆으로 몇개
     EXCEPTIONS
       cntl_error              = 1                  " See Superclass
       cntl_system_error       = 2                  " See Superclass
       others                  = 3.

*   Call METHOD gr_split->get_container              "아래 방식이랑 동일.
*      EXPORTING
*        row       = 1                  " Row 첫번째 줄
*        column    = 1                  " Column 천번째 칸
*      RECEIVING
*        container = gr_con_top        " Container
*    ).
*
*    gr_split->get_container(
*      EXPORTING
*        row       = 1                  " Row 첫번째 줄
*        column    = 1                  " Column 천번째 칸
*      RECEIVING
*        container = gr_con_top        " Container
*    ).
*
*     gr_con_top = gt_split->get_container(
*      EXPORTING
*        row       = 1                  " Row 첫번째 줄
*        column    = 1                  " Column 천번째 칸
*    ).

      gr_split->set_row_height(
        EXPORTING
          id                = 1                 " Row ID
          height            = 10                 " Height
        EXCEPTIONS
          cntl_error        = 1                " See CL_GUI_CONTROL
          cntl_system_error = 2                " See CL_GUI_CONTROL
          others            = 3
      ).

      GR_CON_TOP = gr_split->get_container( ROW = 2 COLUMN = 1 ).
      GR_CON_ALV = gr_split->get_container( ROW = 2 COLUMN = 1 ).


      CREATE OBJECT gr_alv
        EXPORTING
          i_parent                = gr_con_alv       " Parent Container
        EXCEPTIONS
          error_cntl_create       = 1                " Error when creating the control
          error_cntl_init         = 2                " Error While Initializing Control
          error_cntl_link         = 3                " Error While Linking Control
          error_dp_create         = 4                " Error While Creating DataProvider Control
          others                  = 5.

*     GR_ALV = NEW CL_GUI_ALV_GRID( i_parent = gr_con_avl ).
*     GR_ALV = NEW #( i_parent = gr_con_avl ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_layout_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  CLEAR gs_layout.
  gs_layout-zebra      = ABAP_ON.    "'X'.
  gs_layout-sel_mode   = 'D'.      "A: 행열, B: 단일행 C:복수행 D: 셀단위.
  gs_layout-cwidth_opt = ABAP_ON.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_fcat_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_fcat_0100 .

  DATA lt_fieldcat TYPE kkblo_t_fieldcat.      "KKB함수에 넣어줘야하기 때문에 conversion 용도.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = SY-REPID         " Internal table declaration program
*      i_tabname              = 'GS_SCARR'      " Name of table to be displayed
      i_strucname            = 'SCARR'
      i_inclname             = SY-REPID
      i_bypassing_buffer     = ABAP_ON          " Ignore buffer while reading
      i_buffer_active        = ABAP_OFF
    CHANGING
      ct_fieldcat            = LT_FIELDCAT        " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1
      others                 = 2.

  IF LT_FIELDCAT[] IS INITIAL.
    MESSAGE '필드 카탈로그 구성 중 오류가 발생했습니다.' TYPE 'E'.
  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        IT_FIELDCAT_KKBLO         = LT_FIELDCAT
      IMPORTING
        ET_FIELDCAT_LVC           = GT_FCAT
      EXCEPTIONS
        IT_DATA_MISSING           = 1
        OTHERS                    = 2.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  CALL METHOD gr_alv->set_table_for_first_display
    EXPORTING
      is_layout                     = gs_layout             " Layout
    CHANGING
      it_outtab                     =  gt_scarr[]           " Output Table
      it_fieldcatalog               =  gt_fcat[]            " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      others                        = 4.

ENDFORM.
