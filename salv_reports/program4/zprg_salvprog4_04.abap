*&---------------------------------------------------------------------*
*& Report ZPRG_SALVPROG1_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_salvprog4_04.

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

DATA: lo_salv TYPE REF TO cl_salv_table. "object for alv report

DATA: lo_columns TYPE REF TO cl_salv_columns_table. "object for changing column position

DATA: lo_colname TYPE REF TO cl_salv_column."object for changing column's long text

DATA: lo_sorts TYPE REF TO cl_salv_sorts."object for sort

DATA: lo_sorting TYPE REF TO cl_salv_sort."object for sorting a column

DATA: lo_filter TYPE REF TO cl_salv_filters. "object for filter

DATA: lo_filtering TYPE REF TO cl_salv_filter. "object for filtering


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

CALL METHOD lo_salv->if_salv_gui_om_table_info~get_columns "method of cl_salv_table to get object of columns
  RECEIVING
    value = lo_columns.

CALL METHOD lo_columns->set_column_position "method of cl_salv_columns_table to change the position of columns
  EXPORTING
    columnname = 'ERDAT'
    position   = 3.

CALL METHOD lo_columns->set_column_position
  EXPORTING
    columnname = 'ERZET'
    position   = 2.

TRY.
    CALL METHOD lo_columns->get_column "method of cl_salv_columns_table to get object of single column
      EXPORTING
        columnname = 'VBELN'
      RECEIVING
        value      = lo_colname.
  CATCH cx_salv_not_found.
ENDTRY.

CALL METHOD lo_colname->set_long_text   "method of cl_salv_column to change the long text of a column
  EXPORTING
    value = 'DOCUMENT NUMBER'.


CALL METHOD lo_salv->if_salv_gui_om_table_info~get_sorts "method of cl_salv_table to get object of sorting
  RECEIVING
    value = lo_sorts.

TRY.
    CALL METHOD lo_sorts->add_sort "method of cl_salv_sort for sorting
      EXPORTING
        columnname = 'VBELN'
        position   = 1
        sequence   = if_salv_c_sort=>sort_up
        subtotal   = if_salv_c_bool_sap=>false
        group      = if_salv_c_sort=>group_none
        obligatory = if_salv_c_bool_sap=>false
      RECEIVING
        value      = lo_sorting.
  CATCH cx_salv_not_found.
  CATCH cx_salv_existing.
  CATCH cx_salv_data_error.
ENDTRY.

CALL METHOD lo_salv->if_salv_gui_om_table_info~get_filters
  RECEIVING
    value = lo_filter.

TRY.
    CALL METHOD lo_filter->add_filter
      EXPORTING
        columnname = 'POSNR' "'POSNR'
        sign       = 'I'  "'E'
        option     = 'BT'   "'EQ'
        low        = '10'  "  '10'
*        high       = '20'
      RECEIVING
        value      = lo_filtering.
  CATCH cx_salv_not_found.
  CATCH cx_salv_data_error.
  CATCH cx_salv_existing.
ENDTRY.

TRY.
CALL METHOD lo_filtering->add_selopt "method for filter condition (posnr = 10 & 30 not 20, no continuous range but random values)
  EXPORTING
    sign   = 'I'
    option = 'EQ'
    low    = '30'
*    high   =
*  RECEIVING
*    value  =
    .
  CATCH cx_salv_data_error.
ENDTRY.


CALL METHOD lo_salv->if_salv_gui_om_table_action~display
*  IMPORTING
*    exit_caused_by_caller =
*    exit_caused_by_user   =
  .