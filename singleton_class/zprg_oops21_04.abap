*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS21_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops21_04.


DATA: lo_obj TYPE REF TO zsingleton_class04.

PARAMETERS: p_inp1 TYPE i,
            p_inp2 TYPE i.

DATA: lv_output TYPE i.

CALL METHOD zsingleton_class04=>get_instance
  RECEIVING
    ro_object = lo_obj.

CALL METHOD lo_obj->sum
  EXPORTING
    p_input1 = p_inp1
    p_input2 = p_inp2
  IMPORTING
    p_output = lv_output.

WRITE:  lv_output.