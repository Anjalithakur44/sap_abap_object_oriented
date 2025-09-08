*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS19_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops19_04.
* TYPES through Global Class.
DATA: lv_vbeln TYPE vbak-vbeln.
SELECT-OPTIONS: s_vbeln FOR lv_vbeln.

DATA: lt_final  TYPE zprg_sales_order_dtl_04=>ltty_output,
      lwa_final TYPE zprg_sales_order_dtl_04=>lty_output.

DATA: lo_obj TYPE REF TO zprg_sales_order_dtl_04.
CREATE OBJECT lo_obj.

CALL METHOD lo_obj->get_data
  EXPORTING
    svbeln    = s_vbeln[]
  IMPORTING
    lt_output = lt_final.

LOOP AT lt_final INTO lwa_final.
  WRITE: / lwa_final-vbeln, lwa_final-erdat, lwa_final-erzet, lwa_final-ernam, lwa_final-vbtyp, lwa_final-posnr, lwa_final-matnr.
ENDLOOP.