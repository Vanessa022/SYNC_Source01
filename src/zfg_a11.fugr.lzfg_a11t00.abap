*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSAPLANE_A11....................................*
DATA:  BEGIN OF STATUS_ZSAPLANE_A11                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSAPLANE_A11                  .
CONTROLS: TCTRL_ZSAPLANE_A11
            TYPE TABLEVIEW USING SCREEN '0500'.
*.........table declarations:.................................*
TABLES: *ZSAPLANE_A11                  .
TABLES: ZSAPLANE_A11                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
