*&---------------------------------------------------------------------*
*& Report ZBC400_SA11_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC400_SA11_COMPUTE.

PARAMETERS: pa_int1 TYPE i,
            pa_int2 TYPE i,
            pa_op TYPE c LENGTH 1.

DATA gv_result TYPE p LENGTH 16 DECIMALS 2.

IF ( pa_op = '+' OR
     pa_op = '-' OR
     pa_op = '*' OR
     pa_op = '/' AND pa_int2 <> 0 ).

CASE pa_op.
  WHEN '+'.
    gv_result = pa_int1 + pa_int2.
  WHEN '-'.
    gv_result = pa_int1 - pa_int2.
  WHEN '*'.
    gv_result = pa_int1 * pa_int2.
  WHEN '/'.
    gv_result = pa_int1 / pa_int2.
ENDCASE.

WRITE: 'Answer:'(M01), gv_result.

ELSEIF pa_op = '/' AND pa_int2 = '0'.
    WRITE 'The Denominator cannot be 0 in Division!'(M03).


ELSE.
  WRITE 'The Operator is invalid'(M04).

ENDIF.
