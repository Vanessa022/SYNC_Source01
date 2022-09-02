*&---------------------------------------------------------------------*
*& Include          SAPMZC1110001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

  "New Syntax(신문법) 사용하면 INTERNAL TABLE 따로 만들 필요 X.

  SELECT werks, name1, ekorg, land1
    INTO TABLE @DATA(lt_werks)
    FROM t001w.

  IF sy-subrc <> 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'WERKS'
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'GS_DATA-WERKS'
      window_title = TEXT-t01
      value_org    = 'S'
    TABLES
      value_tab    = lt_werks.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  REFRESH gt_data.

  SELECT matnr werks mtart matkl
         menge meins dmbtr waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM zc1tt11_0001.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_qfield
                     pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                     (
                        key        = pv_key
                        fieldname  = pv_field
                        coltext    = pv_text
                        ref_table  = pv_ref_table
                        ref_field  = pv_ref_field
                        qfieldname = pv_qfield
                        cfieldname = pv_cfield
                      )
                    ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .

  IF  gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        container_name = 'GCL_CONTAINER'.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ELSE.
    PERFORM refresh_grid.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA: ls_save TYPE ZC1TT11_0001.
*        lt_save TYPE TABLE OF zc1tt11_0001.

  CLEAR   ls_save.


  IF gs_data-matnr IS INITIAL OR
     gs_data-werks IS INITIAL.
    MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  ls_save = CORRESPONDING #( gs_data ).

  MODIFY ZC1TT11_0001 FROM ls_save.

  IF sy-dbcnt > 0.
    COMMIT WORK AND WAIT.
    MESSAGE s000 WITH TEXT-m01.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s000 WITH TEXT-m02 DISPLAY LIKE 'W'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  DATA: ls_stable TYPE lvc_s_stbl.

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = space.

ENDFORM.
