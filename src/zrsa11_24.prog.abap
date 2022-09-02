*&---------------------------------------------------------------------*
*& Report ZRSA11_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA11_24_TOP                           .    " Global Data

* INCLUDE ZRSA11_24_O01                           .  " PBO-Modules
* INCLUDE ZRSA11_24_I01                           .  " PAI-Modules
 INCLUDE ZRSA11_24_F01                           .  " FORM-Routines

"Event

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT. "PBO

AT SELECTION-SCREEN. "PAI


START-OF-SELECTION.

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_info
    WHERE carrid = pa_car
    AND connid BETWEEN pa_con1 AND pa_con2.
*    WHERE carrid = pa_car
*    AND connid = pa_con1
*    OR carrid = pa_car
*    AND connid = pa_con2.


  LOOP AT gt_info INTO gs_info.
    SELECT SINGLE carrname
      FROM scarr
      INTO gs_info-carrname
      WHERE carrid = gs_info-carrid.

    SELECT SINGLE cityfrom cityto
      FROM spfli
      INTO CORRESPONDING FIELDS OF gs_info
      WHERE carrid = gs_info-carrid
      AND connid = gs_info-connid.

    gs_info-seatremain = gs_info-seatsmax - gs_info-seatsocc.
    gs_info-seatremain_b = gs_info-seatsmax_b - gs_info-seatsocc_b.
    gs_info-seatremain_f = gs_info-seatsmax_f - gs_info-seatsocc_f.

    MODIFY gt_info FROM gs_info.
    CLEAR gs_info.
   ENDLOOP.

cl_demo_output=>display_data( gt_info ).
