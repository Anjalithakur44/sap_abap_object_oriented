*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS12_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops12_04.

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

DATA: lt_fieldcat  TYPE lvc_t_fcat, "fieldcatalog for lvc_fieldcat_merge module
      lwa_fieldcat TYPE lvc_s_fcat.

DATA: lo_contcl TYPE REF TO cl_gui_custom_container. "object for container class
DATA: lo_gridcl TYPE REF TO cl_gui_alv_grid. "object for alv grid class

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

LOOP AT  lt_vbak INTO lwa_vbak.
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

lwa_fieldcat-col_pos = '1'.
lwa_fieldcat-fieldname = 'VBELN'.
lwa_fieldcat-SCRTEXT_L = 'Sales Document Number'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

lwa_fieldcat-col_pos = '2'.
lwa_fieldcat-fieldname = 'ERDAT'.
lwa_fieldcat-SCRTEXT_L = 'Creation Date'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

lwa_fieldcat-col_pos = '3'.
lwa_fieldcat-fieldname = 'ERZET'.
lwa_fieldcat-SCRTEXT_L = 'Creation Time'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

lwa_fieldcat-col_pos = '4'.
lwa_fieldcat-fieldname = 'ERNAM'.
lwa_fieldcat-SCRTEXT_L = 'Username'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

lwa_fieldcat-col_pos = '5'.
lwa_fieldcat-fieldname = 'VBTYP'.
lwa_fieldcat-SCRTEXT_L = 'Document Category'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

lwa_fieldcat-col_pos = '6'.
lwa_fieldcat-fieldname = 'POSNR'.
lwa_fieldcat-SCRTEXT_L = 'Item Number'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

lwa_fieldcat-col_pos = '7'.
lwa_fieldcat-fieldname = 'MATNR'.
lwa_fieldcat-SCRTEXT_L = 'Material Number'.
append lwa_fieldcat to lt_fieldcat.
clear: lwa_fieldcat.

CREATE OBJECT lo_contcl
  EXPORTING
    container_name = 'CONT'. "give any name for container here

CREATE OBJECT lo_gridcl
  EXPORTING
    i_parent = lo_contcl. "passed object of container class as parent of alv grid class

CALL METHOD lo_gridcl->set_table_for_first_display
  CHANGING
    it_outtab                     = lt_final "table which has the data to be displayed
    it_fieldcatalog               = lt_fieldcat "fieldcatalog for the alv report
*   it_sort                       =
*   it_filter                     =
  EXCEPTIONS
    invalid_parameter_combination = 1
    program_error                 = 2
    too_many_lines                = 3
    OTHERS                        = 4.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL SCREEN '0100'. "LAYOUT for container using custom control on a screen

INCLUDE zprg_oops12_04_user_commandi01.
INCLUDE zprg_oops12_04_status_0100o01.