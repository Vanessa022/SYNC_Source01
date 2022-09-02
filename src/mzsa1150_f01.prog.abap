*&---------------------------------------------------------------------*
*& Include          MZSA1150_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*---------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_info .

    CLEAR: zssa11ven_02, zssa11ven_03.

    " Meal Info
    SELECT SINGLE *
      FROM smeal
      INTO CORRESPONDING FIELDS OF zssa11ven_02
     WHERE carrid = zssa11ven_01-carrid
       AND mealnumber = zssa11ven_01-mealnumber.

    " Meal Description
    SELECT SINGLE *
      FROM smealt
      INTO CORRESPONDING FIELDS OF zssa11ven_02
     WHERE carrid = zssa11ven_01-carrid
      AND mealnumber = zssa11ven_01-mealnumber.

    " Meal Price
    SELECT SINGLE price waers
      FROM ztsa11ven
      INTO CORRESPONDING FIELDS OF ZSSA11VEN_02
     WHERE carrid = zssa11ven_01-carrid
       AND mealno = zssa11ven_01-mealnumber.

     " Vendor Info
      SELECT SINGLE *
        FROM ztsa11ven
        INTO CORRESPONDING FIELDS OF zssa11ven_03
        WHERE carrid = zssa11ven_01-carrid
        AND mealno = zssa11ven_01-mealnumber
        AND price = zssa11ven_02-price.

      " Text Table
      SELECT SINGLE LANDX50
        FROM T005T
        INTO zssa11ven_03-LANDX50
       WHERE land1 = zssa11ven_03-land1
         AND SPRAS = sy-langu.

ENDFORM.
