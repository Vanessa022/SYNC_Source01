*&---------------------------------------------------------------------*
*& Report  SAPBC430S_FILL_CLUSTER_TAB                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZBC430_A11_FILL_CLUSTER_TAB                                  .

DATA wa_scarr  TYPE scarr.
DATA wa_spfli  TYPE spfli.
DATA wa_flight TYPE sflight.
DATA wa_saplane TYPE saplane.

DATA my_error TYPE i VALUE 0.


START-OF-SELECTION.


  DELETE FROM zscarr_a11.
  DELETE FROM zspfli_a11.
  DELETE FROM zsflight_a11.
  DELETE FROM zsaplane_a11.


  SELECT *
    FROM scarr
    INTO wa_scarr.
    INSERT INTO zscarr_a11
    VALUES wa_scarr.
  ENDSELECT.

  IF sy-subrc = 0.

    SELECT *
      FROM spfli
      INTO wa_spfli.
      INSERT INTO zspfli_a11
      VALUES wa_spfli.
    ENDSELECT.

    IF sy-subrc = 0.

      SELECT *
        FROM sflight
        INTO wa_flight.
        INSERT INTO zsflight_a11
        VALUES wa_flight.
      ENDSELECT.

        SELECT *
          FROM saplane
          INTO wa_saplane.
          INSERT INTO zsaplane_a11
          VALUES wa_saplane.
        ENDSELECT.

      IF sy-subrc <> 0.
        my_error = 1.
      ENDIF.
    ELSE.
      my_error = 2.
    ENDIF.
  ELSE.
    my_error = 3.
  ENDIF.

  IF my_error = 0.
    WRITE / 'Data transport successfully finished'.
  ELSE.
    WRITE: / 'ERROR:', my_error.
  ENDIF.
