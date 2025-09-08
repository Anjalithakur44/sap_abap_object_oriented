*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS6_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops6_04.
* program to implement abstract class through local class
PARAMETERS: p_vbeln TYPE vbeln_va.
PARAMETERS: p_r1 TYPE c RADIOBUTTON GROUP r1,
            p_r2 TYPE c RADIOBUTTON GROUP r1.
DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.


CLASS abstract_class DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS display ABSTRACT IMPORTING  pvbeln TYPE vbeln_va
                             EXPORTING  perdat TYPE erdat
                                        perzet TYPE erzet
                                        pernam TYPE ernam
                                        pvbtyp TYPE vbtypl
                             EXCEPTIONS wrong_input.
ENDCLASS.

CLASS sales DEFINITION INHERITING FROM abstract_class.
  PUBLIC SECTION.
    METHODS display REDEFINITION.
ENDCLASS.

CLASS sales IMPLEMENTATION.
  METHOD display.
    SELECT SINGLE erdat erzet ernam vbtyp
    FROM vbak
    INTO ( perdat, perzet, pernam, pvbtyp )
    WHERE vbeln = pvbeln.
  ENDMETHOD.
ENDCLASS.

CLASS billing DEFINITION INHERITING FROM abstract_class.
  PUBLIC SECTION.
    METHODS display REDEFINITION.
ENDCLASS.

CLASS billing IMPLEMENTATION.
  METHOD display.
    SELECT SINGLE vbtyp ernam erzet erdat
      FROM vbrk
      INTO ( pvbtyp, pernam, perzet, perdat )
      WHERE vbeln = pvbeln.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_obj1 TYPE REF TO sales.
  CREATE OBJECT lo_obj1.

  DATA: lo_obj2 TYPE REF TO billing.
  CREATE OBJECT lo_obj2.
  IF p_r1 ='X'.
    lo_obj1->display( EXPORTING pvbeln = p_vbeln
                      IMPORTING perdat = lv_erdat
                                perzet = lv_erzet
                                pernam = lv_ernam
                                pvbtyp = lv_vbtyp
                      ).
    IF sy-subrc = 0.
      WRITE: 'The Sales Order details are:',
      / lv_erdat,
      / lv_erzet,
      / lv_ernam,
      / lv_vbtyp.
    ENDIF.

  ELSEIF p_r2 = 'X'.
    lo_obj2->display( EXPORTING pvbeln = p_vbeln
                      IMPORTING perdat = lv_erdat
                                perzet = lv_erzet
                                pernam = lv_ernam
                                pvbtyp = lv_vbtyp
                                ).
    IF sy-subrc = 0.
      WRITE: 'The Billing details are:',
          / lv_erdat,
          / lv_erzet,
          / lv_ernam,
          / lv_vbtyp.
    ENDIF.

  ENDIF.