*&---------------------------------------------------------------------*
*& Include          MZSA1190_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      "Get Airline Info
      PERFORM get_airline_name USING zssa1190-carrid
                               CHANGING zssa1190-carrname.

      "Get Meal Text
      PERFORM get_meal_text USING zssa1190-carrid
                                  zssa1190-mealnumber
                                  sy-langu  " 'E'
                            CHANGING zssa1190-mealnumber_t.

    WHEN 'SEARCH'.
      PERFORM get_meal_info USING zssa1190-carrid
                                  zssa1190-mealnumber
                            CHANGING zssa1191.

      PERFORM get_vendor_info USING 'M'
                                    zssa1190-carrid
                                    zssa1190-mealnumber
                              CHANGING zssa1193.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
