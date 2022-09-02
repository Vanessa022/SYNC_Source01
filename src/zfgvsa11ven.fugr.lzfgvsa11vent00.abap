*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA1103........................................*
TABLES: ZVSA1103, *ZVSA1103. "view work areas
CONTROLS: TCTRL_ZVSA1103
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA1103. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1103.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1103_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1103.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1103_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1103_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1103.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1103_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA1101                       .
