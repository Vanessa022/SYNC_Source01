*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA1104........................................*
TABLES: ZVSA1104, *ZVSA1104. "view work areas
CONTROLS: TCTRL_ZVSA1104
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA1104. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1104.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1104_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1104.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1104_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1104_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1104.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1104_TOTAL.

*...processing: ZVSA1199........................................*
TABLES: ZVSA1199, *ZVSA1199. "view work areas
CONTROLS: TCTRL_ZVSA1199
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA1199. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1199.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1199_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1199.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1199_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1199_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1199.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1199_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA1102                       .
TABLES: ZTSA1102_T                     .
TABLES: ZTSA1199                       .
