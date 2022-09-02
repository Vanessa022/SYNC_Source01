*&---------------------------------------------------------------------*
*& Include          ZBC405_A11_SOLE01
*&---------------------------------------------------------------------*


INITIALIZATION.

  s_fldate-low = '20200101'.
*  s_fldate-low(4) = s_fldate-low(4) - 2.  "년도 설정
*  s_fldate-low(4) = '2018'. "년도
*  s_fldate-low+4(2) = '09'. "월
*  s_fldate-low+6(2) = '01'. "일
  s_fldate-high = sy-datum.

  s_fldate-sign = 'I'.
  s_fldate-option = 'BT'.

  APPEND s_fldate.


 s_car-low = 'AA'.
 s_car-high = 'QF'.
 s_car-sign = 'I'.
 s_car-option = 'BT'.
 APPEND s_car.
 CLEAR s_car.

 s_car-low = 'AZ'.
 s_car-sign = 'E'.
 s_car-option = 'EQ'.
 APPEND s_car.
 CLEAR s_car.



*START-OF-SELECTION.

*  SELECT *
*    FROM dv_flights
*    INTO gs_flight
*    WHERE carrid = p_car AND
*                   connid = p_con AND
*                   fldate IN s_fldate.
*
*
*    WRITE: /10(5) gs_flight-carrid,
*            16(5) gs_flight-connid,
*            gs_flight-fldate,
*            gs_flight-price CURRENCY gs_flight-currency.
*  ENDSELECT.


  CASE 'X'.

    WHEN p_all.
      SELECT * FROM dv_flights INTO gs_flight
                               WHERE carrid IN s_car AND
                                     connid  IN s_con AND
                                     fldate IN s_fldate.


        WRITE  : /10(5) gs_flight-carrid,
                  16(5) gs_flight-connid,
                  22(10) gs_flight-fldate,
                  gs_flight-price CURRENCY  gs_flight-currency,
                  gs_flight-currency.


      ENDSELECT.

    WHEN p_dom.

      SELECT * FROM dv_flights INTO gs_flight
                         WHERE carrid IN s_car AND
                               connid  IN s_con AND
                               fldate IN s_fldate AND
                               countryfr = dv_flights~countryto.


        WRITE  : /10(5) gs_flight-carrid,
                  16(5) gs_flight-connid,
                  22(10) gs_flight-fldate,
                  gs_flight-price CURRENCY  gs_flight-currency,
                  gs_flight-currency.


      ENDSELECT.




    WHEN p_int.

      SELECT * FROM dv_flights INTO gs_flight
                         WHERE carrid IN s_car AND
                               connid  IN s_con AND
                               fldate IN s_fldate AND
                               countryfr NE dv_flights~countryto.


        WRITE  : /10(5) gs_flight-carrid,
                  16(5) gs_flight-connid,
                  22(10) gs_flight-fldate,
                  gs_flight-price CURRENCY  gs_flight-currency,
                  gs_flight-currency.


      ENDSELECT.

  ENDCASE.
