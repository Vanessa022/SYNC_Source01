class ZCLC111_0001 definition
  public
  final
  create public .

public section.

  methods GET_AIRLINE_INFO
    importing
      !PI_CARRID type SCARR-CARRID
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
    changing
      !ET_AIRLINE type ZC1TT11001 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC111_0001 IMPLEMENTATION.


  METHOD get_airline_info.

    IF pi_carrid IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
    ENDIF.

    SELECT carrid carrname currcode url
      FROM scarr
      INTO CORRESPONDING FIELDS OF TABLE et_airline
      WHERE carrid = pi_carrid.

    IF  sy-subrc <> 0.
      pe_code = 'E'.
      pe_msg = TEXT-e02.
      EXIT.
    ELSE.
      pe_code = 'S'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
