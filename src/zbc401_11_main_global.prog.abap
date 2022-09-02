*&---------------------------------------------------------------------*
*& Report ZBC401_11_MAIN_GLOBAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC401_11_MAIN_GLOBAL.

DATA : go_airplane TYPE REF TO  zcl_airplane_a11.
DATA : gt_airplanes TYPE TABLE OF REF TO zcl_airplane_a11.


START-OF-SELECTION.

  CALL METHOD zcl_airplane_a11=>display_n_o_airplanes.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ELSE.

    APPEND go_airplane TO gt_airplanes.
  ENDIF.



  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ELSE.

    APPEND go_airplane TO gt_airplanes.
  ENDIF.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Herculs'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ELSE.

    APPEND go_airplane TO gt_airplanes.
  ENDIF.


  LOOP AT gt_airplanes INTO go_airplane.
    CALL METHOD go_airplane->display_attributes.
  ENDLOOP.

CALL METHOD zcl_airplane_a11=>display_n_o_airplanes.
