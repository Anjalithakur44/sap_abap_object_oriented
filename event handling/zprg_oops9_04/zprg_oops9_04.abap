*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS9_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops9_04.
* program for event handling
PARAMETERS: p_vbeln TYPE vbeln_va.

DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    METHODS display IMPORTING pvbeln TYPE vbeln_va
                    EXPORTING perdat TYPE erdat
                              perzet TYPE erzet
                              pernam TYPE ernam
                              pvbtyp TYPE vbtypl.
    EVENTS: no_input, wrong_input.

ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD display. "triggering method
    IF pvbeln IS INITIAL.
      RAISE EVENT no_input.
    ELSE.
      SELECT SINGLE erdat erzet ernam vbtyp
        FROM vbak
        INTO ( perdat, perzet, pernam, pvbtyp )
        WHERE vbeln = pvbeln.
      IF sy-subrc <> 0.
        RAISE EVENT wrong_input.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS class2 DEFINITION.
  PUBLIC SECTION.
    METHODS message FOR EVENT no_input OF class1. " event handler method.
    METHODS msg FOR EVENT wrong_input OF class1. " event handler method.
ENDCLASS.

CLASS class2 IMPLEMENTATION.
  METHOD message.
    WRITE: TEXT-000.
  ENDMETHOD.
  METHOD msg.
    WRITE: TEXT-001.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_obj1 TYPE REF TO class1.
  DATA: lo_obj2 TYPE REF TO class2.

  CREATE OBJECT lo_obj1.
  CREATE OBJECT lo_obj2.

*  Register the event_handler method
  IF p_vbeln IS INITIAL.
    SET HANDLER lo_obj2->message FOR lo_obj1.
  ELSE.
    SET HANDLER lo_obj2->msg FOR lo_obj1.
  ENDIF.
  lo_obj1->display( EXPORTING pvbeln = p_vbeln
    IMPORTING perdat = lv_erdat
      perzet = lv_erzet
      pernam = lv_ernam
      pvbtyp = lv_vbtyp
       ).
  IF lv_erdat IS NOT INITIAL AND lv_erzet IS NOT INITIAL AND lv_ernam IS NOT INITIAL AND lv_vbtyp IS NOT INITIAL.
    WRITE: 'The Sales Order details', / lv_erdat,
    / lv_erzet,
    / lv_ernam,
    / lv_vbtyp.
  ENDIF.