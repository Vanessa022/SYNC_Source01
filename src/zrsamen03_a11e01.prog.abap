*&---------------------------------------------------------------------*
*& Include          ZRSAMAR02E01
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT *
  FROM sflight
  INTO TABLE gt_sflight_high
  WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_fld.

  SELECT carrid carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_scarr.

  LOOP AT gt_sflight_high INTO gs_sflight.
    CLEAR gs_scarr.
    READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = gs_sflight-carrid.

    gs_sflight-carrname = gs_scarr-carrname.

    MODIFY gt_sflight_high FROM gs_sflight.
  ENDLOOP.
