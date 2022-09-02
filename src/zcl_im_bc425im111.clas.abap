class ZCL_IM_BC425IM111 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK11 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BC425IM111 IMPLEMENTATION.


  method IF_EX_BADI_BOOK11~CHANGE_VLINE.
    c_pos = c_pos + 25.
  endmethod.


  method IF_EX_BADI_BOOK11~OUTPUT.
    DATA: name TYPE s_custname.

    SELECT SINGLE name FROM scustom INTO name
      WHERE id = i_booking-customid.
     WRITE: name.
  endmethod.
ENDCLASS.
