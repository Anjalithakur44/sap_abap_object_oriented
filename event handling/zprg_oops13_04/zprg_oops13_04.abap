*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS13_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops13_04.

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

DATA: lt_fieldcatvbak  TYPE lvc_t_fcat,
      lwa_fieldcatvbak TYPE lvc_s_fcat.

DATA: lt_fieldcatvbap  TYPE lvc_t_fcat,
      lwa_fieldcatvbap TYPE lvc_s_fcat.

DATA: lo_cont1 TYPE REF TO cl_gui_custom_container,
      lo_cont2 TYPE REF TO cl_gui_custom_container.

CREATE OBJECT lo_cont1 EXPORTING container_name = 'CONT1'. "object creation for Container 1
CREATE OBJECT lo_cont2 EXPORTING container_name = 'CONT2'. "object creation for Container 2

DATA: lo_grid1 TYPE REF TO cl_gui_alv_grid,
      lo_grid2 TYPE REF TO cl_gui_alv_grid.

* logic for double click event based functionality
DATA: lt_rows  TYPE lvc_t_row, "internal table for fetching row index that was double clicked
      lwa_rows TYPE lvc_s_row.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    METHODS handle FOR EVENT double_click OF cl_gui_alv_grid. "event handler method for double click event of alv grid class
 * METHODS handle FOR EVENT hotspot_click OF cl_gui_alv_grid. "event handler method for hotspot click event of alv 
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD handle.
    CALL METHOD lo_grid1->get_selected_rows
      IMPORTING
        et_index_rows = lt_rows "provides the row index fetched
*       et_row_no     =
      .
    READ TABLE lt_rows INTO lwa_rows INDEX 1. "contains row index
    IF sy-subrc = 0.
      READ TABLE lt_vbak INTO lwa_vbak INDEX lwa_rows-index. "fetches the data from vbak table where the row index matches

      IF sy-subrc = 0.
        SELECT vbeln posnr matnr
          FROM vbap
          INTO TABLE lt_vbap
          WHERE vbeln = lwa_vbak-vbeln. "fetched data from vbap table on the basis of work area of vbak table

        CALL METHOD lo_grid2->set_table_for_first_display "called method for second alv report in CONT2
          CHANGING
            it_outtab                     = lt_vbap
            it_fieldcatalog               = lt_fieldcatvbap
*           it_sort                       =
*           it_filter                     =
          EXCEPTIONS
            invalid_parameter_combination = 1
            program_error                 = 2
            too_many_lines                = 3
            OTHERS                        = 4.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  SELECT vbeln erdat erzet ernam vbtyp
  FROM vbak
  INTO TABLE lt_vbak
  WHERE vbeln IN s_vbeln.
* fieldcatalog of vbak table
  lwa_fieldcatvbak-col_pos = '1'.
  lwa_fieldcatvbak-fieldname = 'VBELN'.
  lwa_fieldcatvbak-tabname = 'LT_VBAK'.
  lwa_fieldcatvbak-scrtext_l = 'SALES DOCUMENT NUMBER'.
* lwa_fieldcatvbak-hotspot = 'X'. "turned hotspot functionality on when double click is not required
  APPEND lwa_fieldcatvbak TO lt_fieldcatvbak.
  CLEAR: lwa_fieldcatvbak.

  lwa_fieldcatvbak-col_pos = '2'.
  lwa_fieldcatvbak-fieldname = 'ERDAT'.
  lwa_fieldcatvbak-tabname = 'LT_VBAK'.
  lwa_fieldcatvbak-scrtext_l = 'CREATION DATE'.
  APPEND lwa_fieldcatvbak TO lt_fieldcatvbak.
  CLEAR: lwa_fieldcatvbak.

  lwa_fieldcatvbak-col_pos = '3'.
  lwa_fieldcatvbak-fieldname = 'ERZET'.
  lwa_fieldcatvbak-tabname = 'LT_VBAK'.
  lwa_fieldcatvbak-scrtext_l = 'TIME'.
  APPEND lwa_fieldcatvbak TO lt_fieldcatvbak.
  CLEAR: lwa_fieldcatvbak.

  lwa_fieldcatvbak-col_pos = '4'.
  lwa_fieldcatvbak-fieldname = 'ERNAM'.
  lwa_fieldcatvbak-tabname = 'LT_VBAK'.
  lwa_fieldcatvbak-scrtext_l = 'USERNAME'.
  APPEND lwa_fieldcatvbak TO lt_fieldcatvbak.
  CLEAR: lwa_fieldcatvbak.

  lwa_fieldcatvbak-col_pos = '5'.
  lwa_fieldcatvbak-fieldname = 'VBTYP'.
  lwa_fieldcatvbak-tabname = 'LT_VBAK'.
  lwa_fieldcatvbak-scrtext_l = 'DOCUMENT CATEGORY'.
  APPEND lwa_fieldcatvbak TO lt_fieldcatvbak.
  CLEAR: lwa_fieldcatvbak.

  CREATE OBJECT lo_grid1 EXPORTING i_parent = lo_cont1. " object creation of grid class1

  CALL METHOD lo_grid1->set_table_for_first_display  "called method for first alv report in CONT1
    CHANGING
      it_outtab                     = lt_vbak
      it_fieldcatalog               = lt_fieldcatvbak
*     it_sort                       =
*     it_filter                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
* fieldcatalog for vbap table
  lwa_fieldcatvbap-col_pos = '1'.
  lwa_fieldcatvbap-fieldname = 'VBELN'.
  lwa_fieldcatvbap-tabname = 'LT_VBAP'.
  lwa_fieldcatvbap-scrtext_l = 'SALES DOCUMENT NUMBER'.
  APPEND lwa_fieldcatvbap TO lt_fieldcatvbap.
  CLEAR: lwa_fieldcatvbap.

  lwa_fieldcatvbap-col_pos = '2'.
  lwa_fieldcatvbap-fieldname = 'POSNR'.
  lwa_fieldcatvbap-tabname = 'LT_VBAKP'.
  lwa_fieldcatvbap-scrtext_l = 'ITEM NUMBER'.
  APPEND lwa_fieldcatvbap TO lt_fieldcatvbap.
  CLEAR: lwa_fieldcatvbap.

  lwa_fieldcatvbap-col_pos = '3'.
  lwa_fieldcatvbap-fieldname = 'MATNR'.
  lwa_fieldcatvbap-tabname = 'LT_VBAP'.
  lwa_fieldcatvbap-scrtext_l = 'MATERIAL NUMBER'.
  APPEND lwa_fieldcatvbap TO lt_fieldcatvbap.
  CLEAR: lwa_fieldcatvbap.

  CREATE OBJECT lo_grid2 EXPORTING i_parent = lo_cont2. " object creation of grid class2

  DATA: lo_obj TYPE REF TO class1.
  CREATE OBJECT lo_obj. " object creation for class1 for event handling
  SET HANDLER lo_obj->handle FOR lo_grid1. "event registration
  CALL SCREEN '100'. "layout for the two containers CONT1 & CONT2 using custom control

  INCLUDE zprg_oops13_04_user_commandi01."logic for back button