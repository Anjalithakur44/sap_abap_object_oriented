*&---------------------------------------------------------------------*
*& Report ZPRG_SALVPROG1_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_salvprog3_04.

TABLES: vbak.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.

TYPES: BEGIN OF lty_vbak,
         vbeln TYPE vbeln_va,
         erdat TYPE erdat,
         erzet TYPE erzet,
         ernam TYPE ernam,
         vbtyp TYPE vbtypl,
       END OF lty_vbak.

DATA: lt_vbak  TYPE TABLE OF lty_vbak,
      lwa_vbak TYPE lty_vbak.

TYPES: BEGIN OF lty_vbap,
         vbeln TYPE vbeln_va,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
       END OF lty_vbap.

DATA: lt_vbap  TYPE TABLE OF lty_vbap,
      lwa_vbap TYPE lty_vbap.

TYPES: BEGIN OF lty_final,
         vbeln TYPE vbeln_va,
         erdat TYPE erdat,
         erzet TYPE erzet,
         ernam TYPE ernam,
         vbtyp TYPE vbtypl,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
       END OF lty_final.

DATA: lt_final  TYPE TABLE OF lty_final,
      lwa_final TYPE lty_final.

DATA: lo_salv TYPE REF TO cl_salv_table.

DATA: lo_functions TYPE REF TO cl_salv_functions_list. "object for functions

SELECT vbeln erdat erzet ernam vbtyp
  FROM vbak
  INTO TABLE lt_vbak
  WHERE vbeln IN s_vbeln.

IF lt_vbak IS NOT INITIAL.
  SELECT vbeln posnr matnr
    FROM vbap
    INTO TABLE lt_vbap
    FOR ALL ENTRIES IN lt_vbak
    WHERE vbeln = lt_vbak-vbeln.
ENDIF.

LOOP AT lt_vbak INTO lwa_vbak.
  LOOP AT lt_vbap INTO lwa_vbap WHERE vbeln = lwa_vbak-vbeln.
    lwa_final-vbeln = lwa_vbak-vbeln.
    lwa_final-erdat = lwa_vbak-erdat.
    lwa_final-erzet = lwa_vbak-erzet.
    lwa_final-ernam = lwa_vbak-ernam.
    lwa_final-vbtyp = lwa_vbak-vbtyp.
    lwa_final-posnr = lwa_vbap-posnr.
    lwa_final-matnr = lwa_vbap-matnr.
    APPEND lwa_final TO lt_final.
    CLEAR: lwa_final.
  ENDLOOP.
ENDLOOP.

TRY.
    CALL METHOD cl_salv_table=>factory
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
      IMPORTING
        r_salv_table = lo_salv
      CHANGING
        t_table      = lt_final.
  CATCH cx_salv_msg.
ENDTRY.

CALL METHOD lo_salv->if_salv_gui_om_table_info~get_functions "method of cl_salv_table class to get object of functions
  RECEIVING
    value = lo_functions.

CALL METHOD lo_functions->set_all " method of cl_salv_functions_list to get all the standard functions in application toolbar
  EXPORTING
    value  = IF_SALV_C_BOOL_SAP=>TRUE
    .

CALL METHOD lo_salv->if_salv_gui_om_table_action~display
*  IMPORTING
*    exit_caused_by_caller =
*    exit_caused_by_user   =
  .