*&---------------------------------------------------------------------*
*& Report ZRSA11_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_12.

DATA gv_carrname TYPE scarr-carrname.
PARAMETERS pa_carr TYPE scarr-carrid.

"Get Airline Name
PERFORM get_airline_name USING pa_carr
                         CHANGING gv_carrname.

*SELECT SINGLE carrname
*  FROM scarr
*  INTO gv_carrname
*  WHERE carrid = pa_carr.

  "Display Airline Name
WRITE gv_carrname.

*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PA_CARR
*&      <-- GV_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING p_code
                       CHANGING p_carrname.
  p_code = 'UA'.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
    WHERE carrid = p_code.
    WRITE 'Test pa_carr:'.
    WRITE pa_carr.
ENDFORM.
