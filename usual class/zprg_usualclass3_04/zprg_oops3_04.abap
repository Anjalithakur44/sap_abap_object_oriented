*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS3_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops3_04.

DATA: lv_vbeln TYPE vbeln_va.
SELECT-OPTIONS: s_vbeln FOR lv_vbeln.

DATA: lt_final  TYPE TABLE OF zstrvbakbap_04,
      lwa_final TYPE zstrvbakbap_04.

DATA: lo_obj TYPE REF TO zprg_usualclass3_04.
CREATE OBJECT lo_obj.

CALL METHOD lo_obj->get_mutiple_data
  EXPORTING
    svbeln      = s_vbeln[]
  IMPORTING
    lt_output   = lt_final
  EXCEPTIONS
    wrong_input = 1
    OTHERS      = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
  MESSAGE e008(zmessage_04).
ELSE.
  WRITE: / sy-uline(102).
  WRITE: / sy-vline, TEXT-000 COLOR 2 INTENSIFIED ON,
  17 sy-vline, TEXT-001 COLOR 2 INTENSIFIED ON,
  33 sy-vline, TEXT-002 COLOR 2 INTENSIFIED ON,
  49 sy-vline, TEXT-003 COLOR 2 INTENSIFIED ON,
  60 sy-vline, TEXT-004 COLOR 2 INTENSIFIED ON,
  82 sy-vline, TEXT-005 COLOR 2 INTENSIFIED ON,
  102 sy-vline.
  WRITE: / sy-uline(102).
  LOOP AT lt_final INTO lwa_final.

    WRITE: / sy-vline , lwa_final-vbeln UNDER TEXT-000,
    17 sy-vline , lwa_final-erdat UNDER TEXT-001,
    33 sy-vline , lwa_final-erzet UNDER TEXT-002,
    49 sy-vline , lwa_final-ernam UNDER TEXT-003,
    60 sy-vline , lwa_final-posnr UNDER TEXT-004,
    82 sy-vline , lwa_final-matnr UNDER TEXT-005,
    102 sy-vline.
    WRITE: / sy-uline(102).
  ENDLOOP.

ENDIF.