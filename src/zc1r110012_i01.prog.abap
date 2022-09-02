*&---------------------------------------------------------------------*
*& Include          ZC1R110012_I01
*&---------------------------------------------------------------------*

MODULE exit_0100 INPUT.

  CALL METHOD : gcl_grid->free( ), gcl_container->free( ).

  FREE : gcl_grid, gcl_container.

  LEAVE TO SCREEN 0.

ENDMODULE.
