*&---------------------------------------------------------------------*
*& Report ZRSA11_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa11_31_top                           .    " Global Data

* INCLUDE ZRSA11_31_O01                           .  " PBO-Modules
* INCLUDE ZRSA11_31_I01                           .  " PAI-Modules
 INCLUDE zrsa11_31_f01                           .  " FORM-Routines

 INITIALIZATION.

 PERFORM set_default.

 START-OF-SELECTION.
  SELECT *
    FROM ztsa1101
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE entdt BETWEEN pa_ent_b AND pa_ent_e.

    IF sy-subrc IS NOT INITIAL.
*       MESSAGE i016(pn).
       RETURN.
    endif.

*    LOOP AT .
*
*    ENDLOOP.

    cl_demo_output=>display_data( gt_emp ).
