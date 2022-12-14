*&---------------------------------------------------------------------*
*& Report ZRSA11_51
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa11_51_top                           .   " Global Data

INCLUDE zrsa11_51_o01                           .  " PBO-Modules
INCLUDE zrsa11_51_i01                           .  " PAI-Modules
INCLUDE zrsa11_51_f01                           .  " FORM-Routines

INITIALIZATION.
  "기본값 설정
  PERFORM set_init.

AT SELECTION-SCREEN OUTPUT. "PBO
    MESSAGE s000(zmcsa11) WITH 'PBO'.

AT SELECTION-SCREEN. "PAI

START-OF-SELECTION.

  SELECT SINGLE *
    FROM sflight
*    INTO sflight
    WHERE carrid = pa_car
      AND connid = pa_con
      AND fldate IN so_dat[].

  CALL SCREEN 100.
MESSAGE s000(zmcsa11) WITH 'After call Screen'.
