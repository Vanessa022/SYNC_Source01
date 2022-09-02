*&---------------------------------------------------------------------*
*& Report ZRSA11_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA11_25_TOP                           .    " Global Data

* INCLUDE ZRSA11_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA11_25_I01                           .  " PAI-Modules
 INCLUDE ZRSA11_25_F01                           .  " FORM-Routines


 START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_info
    WHERE carrid = pa_car
*      AND connid IN so_con[].
      AND connid BETWEEN pa_con1 AND pa_con2.



cl_demo_output=>display_data( gt_info ).
