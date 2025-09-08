*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS8_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops8_04.

PARAMETERS: p_vbeln TYPE vbeln_va.
PARAMETERS: p_r1 TYPE c RADIOBUTTON GROUP r1.
PARAMETERS: p_r2 TYPE c RADIOBUTTON GROUP r1.

DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.

INTERFACE interface1.
  METHODS sales IMPORTING pvbeln TYPE vbeln_va
                EXPORTING perdat TYPE erdat
                          perzet TYPE erzet
                          pernam TYPE ernam
                          pvbtyp TYPE vbtypl.
ENDINTERFACE.

INTERFACE interface2.
  METHODS bill IMPORTING pvbeln TYPE vbeln_va
               EXPORTING perdat TYPE erdat
                         perzet TYPE erzet
                         pernam TYPE ernam
                         pvbtyp TYPE vbtypl.
ENDINTERFACE.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface1.
    INTERFACES interface2.
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD interface1~sales.
    SELECT erdat erzet ernam vbtyp
      FROM vbak
      INTO ( perdat, perzet, pernam, pvbtyp )
      WHERE vbeln = pvbeln.
    ENDSELECT.
  ENDMETHOD.
  METHOD interface2~bill.
    SELECT vbtyp ernam erzet erdat
      FROM vbrk
      INTO ( pvbtyp, pernam, perzet, perdat )
      WHERE vbeln = pvbeln.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  IF p_r1 = 'X'.
    DATA: lo_obj1 TYPE REF TO class1.
    CREATE OBJECT lo_obj1.
    lo_obj1->interface1~sales( EXPORTING pvbeln = p_vbeln
     IMPORTING perdat = lv_erdat
       perzet = lv_erzet
       pernam = lv_ernam
       pvbtyp = lv_vbtyp
      ).
    WRITE: 'The Sales Order details:', / lv_erdat,
    / lv_erzet,
    / lv_ernam,
    / lv_vbtyp.
  ELSEIF p_r2 = 'X'.
    DATA: lo_obj2 TYPE REF TO class1.
    CREATE OBJECT lo_obj2.
    lo_obj2->interface2~bill( EXPORTING pvbeln = p_vbeln
     IMPORTING perdat = lv_erdat
       perzet = lv_erzet
       pernam = lv_ernam
       pvbtyp = lv_vbtyp
      ).
    WRITE: 'The Billing details:', / lv_vbtyp,
    / lv_ernam,
    / lv_erzet,
    / lv_erdat.
  ENDIF.