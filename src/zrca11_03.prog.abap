*&---------------------------------------------------------------------*
*& Report ZRCA11_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRCA11_03.

DATA gv_i TYPE i.

*gv_i = 10 / 0.

WRITE gv_i.

MESSAGE 'Message Text' TYPE 'I'.
" 'I', 'S', 'E', 'W', 'A', 'X'.


*I - information
*S - success
*E - error
*W - warning
*A - abort
*X - termination
