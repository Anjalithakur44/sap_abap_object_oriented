REPORT zprg_oops5_04.

PARAMETERS: p_vbeln TYPE vbeln_va.
PARAMETERS: p_r1 TYPE c RADIOBUTTON GROUP r1,
            p_r2 TYPE c RADIOBUTTON GROUP r1.

DATA: lo_obj1 TYPE REF TO zprg_abstractclass2_04.
CREATE OBJECT lo_obj1.

DATA: lo_obj2 TYPE REF TO zprg_abstractclass3_04.
CREATE OBJECT lo_obj2.

DATA: lv_erdat TYPE erdat,
      lv_erzet TYPE erzet,
      lv_ernam TYPE ernam,
      lv_vbtyp TYPE vbtypl.
IF p_r1 = 'X'.
  CALL METHOD lo_obj1->display
    EXPORTING
      pvbeln      = p_vbeln
    IMPORTING
      perdat      = lv_erdat
      perzet      = lv_erzet
      pernam      = lv_ernam
      pvbtyp      = lv_vbtyp
    EXCEPTIONS
      wrong_input = 1
      OTHERS      = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE e008(zmessage_04).
  ELSE.
    WRITE: / 'The Sales Order document details',
    / lv_erdat,
    / lv_erzet,
    / lv_ernam,
    / lv_vbtyp.
  ENDIF.
ELSEIF p_r2 = 'X'.
  CALL METHOD lo_obj2->display
    EXPORTING
      pvbeln      = p_vbeln
    IMPORTING
      perdat      = lv_erdat
      perzet      = lv_erzet
      pernam      = lv_ernam
      pvbtyp      = lv_vbtyp
    EXCEPTIONS
      wrong_input = 1
      OTHERS      = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE e008(zmessage_04).
  ELSE.
    WRITE: / 'The billing document details',
    / lv_erdat,
    / lv_erzet,
    / lv_ernam,
    / lv_vbtyp.
  ENDIF.
ENDIF.