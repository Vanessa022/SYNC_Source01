*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSA1104........................................*
FORM GET_DATA_ZVSA1104.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA1102 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA1104 .
ZVSA1104-MANDT =
ZTSA1102-MANDT .
ZVSA1104-DEPID =
ZTSA1102-DEPID .
ZVSA1104-PHONE =
ZTSA1102-PHONE .
    SELECT SINGLE * FROM ZTSA1102_T WHERE
DEPID = ZTSA1102-DEPID AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA1104-DETEXT =
ZTSA1102_T-DETEXT .
    ENDIF.
<VIM_TOTAL_STRUC> = ZVSA1104.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA1104 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA1104.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA1104-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1102 WHERE
  DEPID = ZVSA1104-DEPID .
    IF SY-SUBRC = 0.
    DELETE ZTSA1102 .
    ENDIF.
    DELETE FROM ZTSA1102_T WHERE
    DEPID = ZTSA1102-DEPID .
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1102 WHERE
  DEPID = ZVSA1104-DEPID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA1102.
    ENDIF.
ZTSA1102-MANDT =
ZVSA1104-MANDT .
ZTSA1102-DEPID =
ZVSA1104-DEPID .
ZTSA1102-PHONE =
ZVSA1104-PHONE .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1102 ##WARN_OK.
    ELSE.
    INSERT ZTSA1102 .
    ENDIF.
    SELECT SINGLE FOR UPDATE * FROM ZTSA1102_T WHERE
    DEPID = ZTSA1102-DEPID AND
    SPRAS = SY-LANGU .
      IF SY-SUBRC <> 0.   "insert preprocessing: init WA
        CLEAR ZTSA1102_T.
ZTSA1102_T-DEPID =
ZTSA1102-DEPID .
ZTSA1102_T-SPRAS =
SY-LANGU .
      ENDIF.
ZTSA1102_T-DETEXT =
ZVSA1104-DETEXT .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1102_T ##WARN_OK.
    ELSE.
    INSERT ZTSA1102_T .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA1104-UPD_FLAG,
STATUS_ZVSA1104-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA1104.
  SELECT SINGLE * FROM ZTSA1102 WHERE
DEPID = ZVSA1104-DEPID .
ZVSA1104-MANDT =
ZTSA1102-MANDT .
ZVSA1104-DEPID =
ZTSA1102-DEPID .
ZVSA1104-PHONE =
ZTSA1102-PHONE .
    SELECT SINGLE * FROM ZTSA1102_T WHERE
DEPID = ZTSA1102-DEPID AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA1104-DETEXT =
ZTSA1102_T-DETEXT .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVSA1104-DETEXT .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA1104 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA1104-DEPID TO
ZTSA1102-DEPID .
MOVE ZVSA1104-MANDT TO
ZTSA1102-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1102'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1102 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1102'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

MOVE ZTSA1102-DEPID TO
ZTSA1102_T-DEPID .
MOVE SY-LANGU TO
ZTSA1102_T-SPRAS .
MOVE ZVSA1104-MANDT TO
ZTSA1102_T-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1102_T'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1102_T TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1102_T'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA1199........................................*
FORM GET_DATA_ZVSA1199.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA1199 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA1199 .
ZVSA1199-MANDT =
ZTSA1199-MANDT .
ZVSA1199-LIFNR =
ZTSA1199-LIFNR .
ZVSA1199-LAND1 =
ZTSA1199-LAND1 .
ZVSA1199-NAME1 =
ZTSA1199-NAME1 .
ZVSA1199-NAME2 =
ZTSA1199-NAME2 .
ZVSA1199-VENCA =
ZTSA1199-VENCA .
ZVSA1199-CARRID =
ZTSA1199-CARRID .
ZVSA1199-MEALNUMBER =
ZTSA1199-MEALNUMBER .
ZVSA1199-PRICE =
ZTSA1199-PRICE .
ZVSA1199-WAERS =
ZTSA1199-WAERS .
<VIM_TOTAL_STRUC> = ZVSA1199.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA1199 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA1199.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA1199-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1199 WHERE
  LIFNR = ZVSA1199-LIFNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA1199 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1199 WHERE
  LIFNR = ZVSA1199-LIFNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA1199.
    ENDIF.
ZTSA1199-MANDT =
ZVSA1199-MANDT .
ZTSA1199-LIFNR =
ZVSA1199-LIFNR .
ZTSA1199-LAND1 =
ZVSA1199-LAND1 .
ZTSA1199-NAME1 =
ZVSA1199-NAME1 .
ZTSA1199-NAME2 =
ZVSA1199-NAME2 .
ZTSA1199-VENCA =
ZVSA1199-VENCA .
ZTSA1199-CARRID =
ZVSA1199-CARRID .
ZTSA1199-MEALNUMBER =
ZVSA1199-MEALNUMBER .
ZTSA1199-PRICE =
ZVSA1199-PRICE .
ZTSA1199-WAERS =
ZVSA1199-WAERS .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1199 ##WARN_OK.
    ELSE.
    INSERT ZTSA1199 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA1199-UPD_FLAG,
STATUS_ZVSA1199-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA1199.
  SELECT SINGLE * FROM ZTSA1199 WHERE
LIFNR = ZVSA1199-LIFNR .
ZVSA1199-MANDT =
ZTSA1199-MANDT .
ZVSA1199-LIFNR =
ZTSA1199-LIFNR .
ZVSA1199-LAND1 =
ZTSA1199-LAND1 .
ZVSA1199-NAME1 =
ZTSA1199-NAME1 .
ZVSA1199-NAME2 =
ZTSA1199-NAME2 .
ZVSA1199-VENCA =
ZTSA1199-VENCA .
ZVSA1199-CARRID =
ZTSA1199-CARRID .
ZVSA1199-MEALNUMBER =
ZTSA1199-MEALNUMBER .
ZVSA1199-PRICE =
ZTSA1199-PRICE .
ZVSA1199-WAERS =
ZTSA1199-WAERS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA1199 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA1199-LIFNR TO
ZTSA1199-LIFNR .
MOVE ZVSA1199-MANDT TO
ZTSA1199-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1199'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1199 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1199'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
