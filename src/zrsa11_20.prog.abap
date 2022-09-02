*&---------------------------------------------------------------------*
*& Report ZRSA11_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa11_20.

DATA: BEGIN OF gs_info,
         CARRID TYPE SPFLI-CARRID,
         CARRNAME TYPE SCARR-CARRNAME,
         CONNID TYPE SPFLI-CONNID,
         COUNTRYFR TYPE SPFLI-COUNTRYFR,
         COUNTRYTO TYPE SPFLI-COUNTRYTO,
      END OF gs_info.

DATA gt_info LIKE TABLE OF gs_info.
DATA gs_spfli TYPE spfli.
DATA gs_scarr TYPE scarr.

*PERFORM get_info.

SELECT SINGLE carrid
    FROM spfli
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE carrid = 'AA'.

  WRITE: gs_info-carrid.


SELECT SINGLE carrname
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE carrid = 'AA'.

  WRITE: gs_info-carrname.


SELECT SINGLE connid countryfr countryto
    FROM spfli
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE carrid = 'AA'.

  WRITE: gs_info-connid, gs_info-countryfr, gs_info-countryto.



*PARAMETERS pa_carr LIKE gs_spfli-carrid.
*
*SELECT SINGLE carrid connid countryfr countryto
*    FROM spfli
*  INTO CORRESPONDING FIELDS OF gs_info
**  INTO gs_scarr
*  WHERE carrid = pa_carr.
*
*  WRITE: gs_info-carrid, gs_info-connid, gs_info-countryfr, gs_info-countryto.


*cl_demo_output=>display_data( gt_info ).
*&---------------------------------------------------------------------*
*& Form get_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM get_info .
*gs_info-carrid = 'AA'.
*gs_info-connid = '0017'.
*gs_info-countryfr = 'US'.
*gs_info-countryto = 'US'.
*APPEND gs_info TO gt_info.
*CLEAR gs_info.
*
*gs_info-carrid = 'AA'.
*gs_info-connid = '0064'.
*gs_info-countryfr = 'US'.
*gs_info-countryto = 'US'.
*APPEND gs_info TO gt_info.
*CLEAR gs_info.
*
*gs_info-carrid = 'AZ'.
*gs_info-connid = '0055'.
*gs_info-countryfr = 'IT'.
*gs_info-countryto = 'DE'.
*APPEND gs_info TO gt_info.
*CLEAR gs_info.
*ENDFORM.
