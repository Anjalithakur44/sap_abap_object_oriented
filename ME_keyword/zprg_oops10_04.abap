*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS10_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops10_04.
* program to demonstrate ME keyword working
CLASS class1 DEFINITION.
  PUBLIC SECTION.
    DATA: lv_value TYPE n VALUE 7. "scope = within this class & subclass
    METHODS display.
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD display.
    DATA: lv_value TYPE n VALUE 5. " scope = within this method
    WRITE: lv_value.
    WRITE: / ME->lv_value. "distinguishes between the 2 same name variables with different value and gives the value declared in class
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_obj TYPE REF TO class1.
  CREATE OBJECT lo_obj.
  lo_obj->display( ).