*----------------------------------------------------------------------*
***INCLUDE LZFGSA11_02F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IV_CARRID
*&      --> IV_CONNID
*&      <-- ES_AIRLINE
*&      <-- ES_CONN
*&      <-- EV_SUBRC
*&---------------------------------------------------------------------*
FORM get_conn_info  USING    VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING p_conn TYPE zssa0082
                             p_subrc.

  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF p_conn
    WHERE carrid = p_carrid
      AND connid = p_connid.
    IF  sy-subrc <> 0.
      p_subrc = 4.
      RETURN.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IV_CARRID
*&      <-- ES_AIRLINE
*&---------------------------------------------------------------------*
FORM get_airline_info  USING    VALUE(p_carrid)
                       CHANGING VALUE(ps_airline) TYPE zssa0081.

  SELECT SINGLE *
    FROM scarr
    INTO CORRESPONDING FIELDS OF ps_airline
    WHERE carrid = p_carrid.

ENDFORM.
