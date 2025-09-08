*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS18_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* Alias through local class
REPORT zprg_oops18_04.
PARAMETERS: p_vbeln TYPE vbak-vbeln.

DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.

INTERFACE sales_interface.
  METHODS get_sales_order_details IMPORTING pvbeln TYPE vbeln_va
                                  EXPORTING perdat TYPE erdat
                                            perzet TYPE erzet
                                            pernam TYPE ernam
                                            pvbtyp TYPE vbtypl.
ENDINTERFACE.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES sales_interface.
    ALIASES get_data FOR sales_interface~get_sales_order_details. "Alias for interface method
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD get_data.
    SELECT SINGLE erdat erzet ernam vbtyp
      FROM vbak
      INTO ( perdat, perzet, pernam, pvbtyp )
      WHERE vbeln = pvbeln.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA: lo_obj TYPE REF TO class1.
  CREATE OBJECT lo_obj.
  lo_obj->get_data( EXPORTING pvbeln = p_vbeln
                    IMPORTING perdat = lv_erdat
                              perzet = lv_erzet
                              pernam = lv_ernam
                              pvbtyp = lv_vbtyp ) .

  WRITE: lv_erdat,
  / lv_erzet,
  / lv_ernam,
  / lv_vbtyp.