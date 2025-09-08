*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS17_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* Alias through global class
REPORT zprg_oops17_04.

PARAMETERS: p_vbeln TYPE vbak-vbeln.

DATA: lo_obj TYPE REF TO zclass_sales_order04.
CREATE OBJECT lo_obj.

DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.

CALL METHOD lo_obj->GET_DATA
  EXPORTING
    pvbeln = p_vbeln
  IMPORTING
    perdat = lv_erdat
    perzet = lv_erzet
    pernam = lv_ernam
    pvbtyp = lv_vbtyp.

WRITE: lv_erdat, / lv_erzet, / lv_ernam, / lv_vbtyp.