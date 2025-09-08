*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS4_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops4_04.
* program to implement usual class through local class
PARAMETERS: p_vbeln TYPE vbeln_va.
DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS display IMPORTING  pvbeln TYPE vbeln_va
                          EXPORTING  perdat TYPE erdat
                                     perzet TYPE erzet
                                     pernam TYPE ernam
                                     pvbtyp TYPE vbtypl
                          EXCEPTIONS wrong_input.
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD display.
    SELECT erdat erzet ernam vbtyp
    FROM vbak
    INTO ( perdat, perzet, pernam, pvbtyp )
    WHERE vbeln = pvbeln.
    ENDSELECT.
    IF sy-subrc <> 0.
      RAISE wrong_input.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
*  DATA: lo_obj TYPE REF TO class1.
*  CREATE OBJECT lo_obj.
  class1=>display( EXPORTING pvbeln = p_vbeln
                      IMPORTING perdat = lv_erdat
                                perzet = lv_erzet
                                pernam = lv_ernam
                                pvbtyp = lv_vbtyp
                      EXCEPTIONS wrong_input = 1 ).

  IF  sy-subrc = 0.
    WRITE: / lv_erdat,
    / lv_erzet,
    / lv_ernam,
    / lv_vbtyp.
  ELSE.
    MESSAGE e008(zmessage_04).
  ENDIF.