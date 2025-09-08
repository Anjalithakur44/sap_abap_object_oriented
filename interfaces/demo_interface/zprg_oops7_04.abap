*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS7_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops7_04.

PARAMETERS: p_vbeln TYPE vbeln_va.
PARAMETERS: p_r1 TYPE c RADIOBUTTON GROUP r1,
            p_r2 TYPE c RADIOBUTTON GROUP r1.


DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.

INTERFACE interface1.
  METHODS display IMPORTING pvbeln TYPE vbeln_va
                  EXPORTING perdat TYPE erdat
                            perzet TYPE erzet
                            pernam TYPE ernam
                            pvbtyp TYPE vbtypl.
ENDINTERFACE.

CLASS sales DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface1.
ENDCLASS.

CLASS sales IMPLEMENTATION.
  METHOD interface1~display.
    SELECT SINGLE erdat erzet ernam vbtyp
      FROM vbak
      INTO ( perdat, perzet, pernam, pvbtyp )
      WHERE vbeln = pvbeln.
  ENDMETHOD.
ENDCLASS.

CLASS bill DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface1.
ENDCLASS.

CLASS bill IMPLEMENTATION.
  METHOD interface1~display.
    SELECT SINGLE vbtyp ernam erzet erdat
      FROM vbrk
      INTO ( pvbtyp, pernam, perzet, perdat )
      WHERE vbeln = pvbeln.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA: lo_obj1 TYPE REF TO sales.
  DATA: lo_obj2 TYPE REF TO bill.
  CREATE OBJECT lo_obj1.
  CREATE OBJECT lo_obj2.

  IF p_r1 = 'X'.
    lo_obj1->interface1~display( EXPORTING pvbeln = p_vbeln
      IMPORTING perdat = lv_erdat
        perzet = lv_erzet
        pernam = lv_ernam
        pvbtyp = lv_vbtyp ).
    WRITE: 'The Sales order details are:', / lv_erdat,
    / lv_erzet,
    / lv_ernam,
    / lv_vbtyp.

  ELSEIF p_r2 = 'X'.
    lo_obj2->interface1~display( EXPORTING pvbeln = p_vbeln
      IMPORTING perdat = lv_erdat
        perzet = lv_erzet
        pernam = lv_ernam
        pvbtyp = lv_vbtyp ).
    WRITE: 'The billing details are:', / lv_vbtyp,
    / lv_ernam,
    / lv_erzet,
    / lv_erdat.

  ENDIF.