*&---------------------------------------------------------------------*
*& Include          ZC1R110014_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-t01.
  PARAMETERS: pa_bukrs TYPE bkpf-bukrs OBLIGATORY,
              pa_gjahr TYPE bkpf-gjahr OBLIGATORY.

  SELECT-OPTIONS: so_belnr FOR bkpf-belnr,
                  so_blart FOR bkpf-blart.

SELECTION-SCREEN END OF BLOCK bl1.
