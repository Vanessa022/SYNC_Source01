*&---------------------------------------------------------------------*
*& Include          ZC1R110016_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR gs_data.
  REFRESH gt_data.

  "Inner Join.
  SELECT a~carrid a~carrname
         b~connid b~fldate b~fldate b~planetype b~price b~currency
         a~url
    FROM scarr AS a
    INNER JOIN sflight AS b
    ON a~carrid = b~carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE a~carrid    IN so_con
     AND b~connid    IN so_car
     AND b~planetype IN so_plnty.

  IF sy-subrc <> 0.
    MESSAGE i001.
    LEAVE LIST-PROCESSING.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fact_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fact_layout .

  gs_layout-zebra       = 'X'.
  gs_layout-cwidth_opt  = 'X'.
  gs_layout-sel_mode    = 'D'.

  IF gs_fcat IS INITIAL.

    PERFORM set_fcat USING:
      'X'   'CARRID'     ' '   'SCARR'      'CARRID',
      ' '   'CONNID'     ' '   'SFLIGHT'    'CONNID',
      ' '   'FLDATE'     ' '   'SFLIGHT'    'FLDATE',
      ' '   'PLANETYPE'  ' '   'SFLIGHT'    'PLANETYPE',
      ' '   'PRICE'      ' '   'SFLIGHT'    'PRICE',
      ' '   'CURRENCY'   ' '   'SFLIGHT'    'CURRENCY',
      ' '   'URL'        ' '   'SCARR'      'URL'.

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
FORM set_fcat  USING  pv_key
                      pv_field
                      pv_text
                      pv_ref_table
                      pv_ref_field.

  gs_fcat = VALUE #( key        = pv_key
                     fieldname  = pv_field
                     coltext    = pv_text
                     ref_table  = pv_ref_table
                     ref_field  = pv_ref_field ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat = VALUE #( BASE gs_fcat
                              cfieldname = 'CURRENCY' ).

*      WHEN 'PLANETYPE'.
*        gs_fcat-hotspot = 'X'.
    ENDCASE.

      APPEND gs_fcat TO gt_fcat.


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

  IF gcl_container IS NOT BOUND.    "alv 얹어져 있지 않으면 만들어라!
    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.


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

  ENDIF.

ENDFORM.
