class ZCL_BC425_12_PX_BADIA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BC425_11_PX_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BC425_12_PX_BADIA IMPLEMENTATION.


  method IF_EX_BC425_11_PX_BADI~WRITE_ADDITIONAL_COLS.

      WRITE: i_wa_spfli-distance, i_wa_spfli-distid.

  endmethod.
ENDCLASS.
