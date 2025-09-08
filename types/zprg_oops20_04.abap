*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS20_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops20_04.
* TYPES through local class.
TYPES: BEGIN OF lty_output,
         vbeln TYPE vbeln_va,
         erdat TYPE erdat,
         erzet TYPE erzet,
         ernam TYPE ernam,
         vbtyp TYPE vbtypl,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
       END OF lty_output. "scope is outside the class.

DATA: lt_final  TYPE TABLE OF lty_output,
      lwa_final TYPE lty_output.

DATA: lv_vbeln TYPE vbeln_va.
SELECT-OPTIONS: s_vbeln FOR lv_vbeln.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF lty_vbeln,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE vbeln_va,
             high   TYPE vbeln_va,
           END OF lty_vbeln.

    TYPES: ltty_vbeln TYPE TABLE OF lty_vbeln.

    TYPES: BEGIN OF lty_output,
             vbeln TYPE vbeln_va,
             erdat TYPE erdat,
             erzet TYPE erzet,
             ernam TYPE ernam,
             vbtyp TYPE vbtypl,
             posnr TYPE posnr_va,
             matnr TYPE matnr,
           END OF lty_output. "scope is within this class

    TYPES: ltty_output TYPE TABLE OF lty_output.

    TYPES: BEGIN OF lty_vbak,
             vbeln TYPE vbeln_va,
             erdat TYPE erdat,
             erzet TYPE erzet,
             ernam TYPE ernam,
             vbtyp TYPE vbtypl,
           END OF lty_vbak.

    TYPES: BEGIN OF lty_vbap,
             vbeln TYPE vbeln_va,
             posnr TYPE posnr_va,
             matnr TYPE matnr,
           END OF lty_vbap.

    METHODS get_data IMPORTING svbeln    TYPE ltty_vbeln
                     EXPORTING lt_output TYPE ltty_output.

ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD get_data.
    DATA: lt_vbak  TYPE TABLE OF lty_vbak,
          lwa_vbak TYPE lty_vbak.

    DATA: lt_vbap  TYPE TABLE OF lty_vbap,
          lwa_vbap TYPE lty_vbap.

    DATA: lwa_output TYPE lty_output.

    SELECT vbeln erdat erzet ernam vbtyp
      FROM vbak
      INTO TABLE lt_vbak
      WHERE vbeln IN svbeln.

    IF lt_vbak IS NOT INITIAL.
      SELECT vbeln posnr matnr
        FROM vbap
        INTO TABLE lt_vbap
        FOR ALL ENTRIES IN lt_vbak
        WHERE vbeln = lt_vbak-vbeln.
    ENDIF.

    LOOP AT lt_vbak INTO lwa_vbak.
      LOOP AT lt_vbap INTO lwa_vbap WHERE vbeln = lwa_vbak-vbeln.
        lwa_output-vbeln = lwa_vbak-vbeln.
        lwa_output-erdat = lwa_vbak-erdat.
        lwa_output-erzet = lwa_vbak-erzet.
        lwa_output-ernam = lwa_vbak-ernam.
        lwa_output-vbtyp = lwa_vbak-vbtyp.
        lwa_output-posnr = lwa_vbap-posnr.
        lwa_output-matnr = lwa_vbap-matnr.
        APPEND lwa_output TO lt_output.
        CLEAR: lwa_output.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA: lo_obj TYPE REF TO class1.
  CREATE OBJECT lo_obj.

  lo_obj->get_data( EXPORTING svbeln = s_vbeln[]
    IMPORTING lt_output = lt_final ).

  LOOP AT lt_final INTO lwa_final.
    WRITE: / lwa_final-vbeln, lwa_final-erdat, lwa_final-erzet, lwa_final-ernam, lwa_final-vbtyp, lwa_final-posnr, lwa_final-matnr.
  ENDLOOP.