*&---------------------------------------------------------------------*
*& Include          MZSA1101_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_PERNR
*&      <-- ZSSA1131
*&---------------------------------------------------------------------*
FORM get_data  USING    VALUE(p_pernr)
               CHANGING ps_info TYPE zssa1131.
"Inner Join
      CLEAR ps_info.
      SELECT SINGLE *
        FROM ztsa0001 AS a INNER JOIN ztsa0002 AS b
          ON a~depid = b~depid                      "Emp Table
        INTO CORRESPONDING FIELDS OF ps_info       " structure variable
       WHERE a~pernr = p_pernr.
      IF sy-subrc IS NOT INITIAL.
        RETURN.   "반복문을 빠져나감
      ENDIF.

        " Dep Text Table
        SELECT SINGLE dtext
          FROM ztsa0002_t
          INTO ps_info-dtext
         WHERE depid = ps_info-depid
           AND spras = sy-langu. "  system logon language를 사용하겠다.

          "Gender Text
*     CASE ps_info-gender.
*       WHEN '1'.
*        ps_info-gender_t = 'Man'(T01).
*      WHEN '2'.
*        ps_info-gender_t = 'Woman'(T02).
*       WHEN OTHERS.
*        ps_info-gender_t = 'None'(T03)..
*     ENDCASE.


DATA: lt_domain TYPE TABLE OF DD07v,  " internal table 선언
      ls_domain LIKE LINE OF lt_domain. "structure variable 선언
     CALL FUNCTION 'GET_DOMAIN_VALUES'
       EXPORTING
         domname               = 'ZDGENDER_A00'
*        TEXT                  = 'X'
*        FILL_DD07L_TAB        = ' '
      TABLES
        values_tab             = lt_domain
*        VALUES_DD07L          =
      EXCEPTIONS
        no_values_found       = 1
        OTHERS                = 2
               .
     IF sy-subrc <> 0.
* Implement suitable error handling here
     ENDIF.

  READ TABLE lt_domain WITH KEY domvalue_l = ps_info-gender
  INTO ls_domain.
  ps_info-gender_t = ls_domain-ddtext.

endform.
