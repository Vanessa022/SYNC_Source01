*&---------------------------------------------------------------------*
*& Include          ZC1R110015_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_emp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_emp_data .

  CLEAR   gs_emp.
  REFRESH gt_emp.

  SELECT pernr ename entdt gender depid carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    FROM ztsa1101
   WHERE pernr IN so_pernr.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  IF  gs_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'PERNR'   ' '   'ZTC1260002'    'PERNR'    'X'  10,
    ' '   'ENAME'   ' '   'ZTC1260002'    'ENAME'    'X'  20,
    ' '   'ENTDT'   ' '   'ZTC1260002'    'ENTDT'    'X'  10,
    ' '   'GENDER'  ' '   'ZTC1260002'    'GENDER'   'X'  5,
    ' '   'DEPID'   ' '   'ZTC1260002'    'DEPID'    'X'  8,
    ' '   'CARRID'  ' '   'ZTC1260002'    'CARRID'   'X'  10.

  ENDIF.
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
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_edit
                     pv_length.

  gt_fcat = VALUE #( BASE gt_fcat
                     (
                       key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                       edit      = pv_edit
                       outputlen = pv_length
                     )
                   ).

*  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_layout .


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
        it_outtab       = gt_emp
        it_fieldcatalog = gt_fcat.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .
*
*  CLEAR gs_emp.
*
*  APPEND gs_emp TO gt_emp.
*
*  PERFORM refresh_grid.

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

*  gs_stable-row = 'X'.
*  gs_stable-col = 'X'.
*
*  CALL METHOD gcl_grid->refresh_table_display
*    EXPORTING
*      is_stable      = gs_stable
*      i_soft_refresh = space.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_emp .

*  DATA : lt_save TYPE TABLE OF ztsa1101.
*
*  REFRESH lt_save.
*
*  CALL METHOD gcl_grid->check_changed_data.
*
*  BREAK-POINT.


ENDFORM.
