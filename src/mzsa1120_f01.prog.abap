*&---------------------------------------------------------------------*
*& Include          MZSA0010_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_info USING VALUE(p_carrid)
                      CHANGING ps_info TYPE zssa0081.

  CLEAR ps_info.
  SELECT SINGLE *
    FROM scarr
    INTO CORRESPONDING FIELDS OF ps_info
   WHERE carrid = p_carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0080_CARRID
*&      --> ZSSA0080_CONNID
*&      <-- ZSSA0082
*&---------------------------------------------------------------------*
FORM get_conn_info  USING    VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING ps_airline TYPE zssa0081
                             ps_conn    TYPE zssa0082
                             p_subrc.
DATA: lv_carrid TYPE zssa0080-carrid,
      lv_connid TYPE zssa0080-connid.
lv_carrid = p_carrid.
lv_connid = p_connid.

CLEAR: p_subrc, ps_airline, ps_conn.
CALL FUNCTION 'ZFSA00_21'
  EXPORTING
    iv_carrid        = lv_carrid
    iv_connid        = lv_connid
  IMPORTING
    es_airline       = ps_airline
    es_conn          = ps_conn
    ev_subrc         = p_subrc.
          .

  "Get Airline Info
  PERFORM get_airline_info USING p_carrid
                           CHANGING ps_airline.

ENDFORM.
