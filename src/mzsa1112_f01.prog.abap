*&---------------------------------------------------------------------*
*& Include          MZSA1110_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_info .

 CLEAR zssa1181.
 SELECT SINGLE *
   FROM scarr
   INTO CORRESPONDING FIELDS OF zssa1181
  WHERE carrid = zssa1180-carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1180_CARRID
*&      --> ZSSA1180_CONNID
*&      <-- ZSSA1182
*&---------------------------------------------------------------------*
FORM get_conn_info  USING    VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING ps_info TYPE zssa1182.

    CLEAR: zssa1181, ps_info.
    SELECT SINGLE *
      FROM spfli
      INTO CORRESPONDING FIELDS OF ps_info
      WHERE carrid = p_carrid
        AND connid = p_connid.
    IF SY-SUBRC <> 0.
      MESSAGE I016(PN) WITH 'Data is not found'.
      RETURN.
    ENDIF.

    "Get Airline Info
     PERFORM get_airline_info.

ENDFORM.
