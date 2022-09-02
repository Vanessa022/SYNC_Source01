*&---------------------------------------------------------------------*
*& Include          ZRSAMEN02_A11E01
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_sflight_high
    WHERE carrid IN so_car       "Select Option 은 table 이기 때문에 IN 사용
      AND connid In so_con
      AND fldate IN so_fld.

    SELECT carrid carrname
      FROM scarr
      INTO CORRESPONDING FIELDS OF TABLE gt_scarr. "모든 정보 가져옴.

      CLEAR gs_sflight.
      LOOP AT gt_sflight_high INTO gs_sflight.
         READ TABLE gt_scarr INTO gs_scarr
         WITH KEY carrid = gs_sflight-carrid.
         gs_sflight-carrname = gs_scarr-carrname.

         MODIFY gt_sflight_high FROM gs_sflight.
         CLEAR gs_sflight.
      ENDLOOP.
