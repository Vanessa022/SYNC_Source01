*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSCARR_A11......................................*
DATA:  BEGIN OF STATUS_ZSCARR_A11                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCARR_A11                    .
CONTROLS: TCTRL_ZSCARR_A11
            TYPE TABLEVIEW USING SCREEN '0100'.
*...processing: ZSFLIGHT_A11....................................*
DATA:  BEGIN OF STATUS_ZSFLIGHT_A11                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSFLIGHT_A11                  .
CONTROLS: TCTRL_ZSFLIGHT_A11
            TYPE TABLEVIEW USING SCREEN '0300'.
*...processing: ZSPFLI_A11......................................*
DATA:  BEGIN OF STATUS_ZSPFLI_A11                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSPFLI_A11                    .
CONTROLS: TCTRL_ZSPFLI_A11
            TYPE TABLEVIEW USING SCREEN '0200'.
*.........table declarations:.................................*
TABLES: *ZSCARR_A11                    .
TABLES: *ZSFLIGHT_A11                  .
TABLES: *ZSPFLI_A11                    .
TABLES: ZSCARR_A11                     .
TABLES: ZSFLIGHT_A11                   .
TABLES: ZSPFLI_A11                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
