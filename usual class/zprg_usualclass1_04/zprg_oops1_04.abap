*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS1_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops1_04.

PARAMETERS: p_vbeln TYPE vbeln_va.
DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtyp.
* calling method without object
CALL METHOD zprg_usualclass1_04=>display
  EXPORTING
    pvbeln      = p_vbeln
  IMPORTING
    perdat      = lv_erdat
    perzet      = lv_erzet
    pernam      = lv_ernam
    pvbtyp      = lv_vbtyp
  EXCEPTIONS
    wrong_input = 1
    others      = 2
        .
IF sy-subrc <> 0.
* Implement suitable error handling here
  MESSAGE e008(zmessage_04).
else.
  WRITE: lv_erdat,
  / lv_erzet,
  / lv_ernam,
  / lv_vbtyp.
ENDIF.



* creating object to call method
*DATA: lo_object TYPE REF TO zprg_usualclass1_04.
*
*CREATE OBJECT lo_object.
*
*CALL METHOD lo_object->display
*  EXPORTING
*    pvbeln      = p_vbeln
*  IMPORTING
*    perdat      = lv_erdat
*    perzet      = lv_erzet
*    pernam      = lv_ernam
*    pvbtyp      = lv_vbtyp
*  EXCEPTIONS
*    wrong_input = 1
*    OTHERS      = 2.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*  MESSAGE e008(zmessage_04).
*
*ELSE.
*  WRITE: lv_erdat,
*  / lv_erzet,
*  / lv_ernam,
*  / lv_vbtyp.
*ENDIF.