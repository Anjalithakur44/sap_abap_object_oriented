*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS15_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops16_04.

PARAMETERS: p_ono TYPE zdeono_04.
DATA: lv_odate TYPE zdeodate_04,
      lv_pm    TYPE zdepm_04,
      lv_ta    TYPE zdetc_04,
      lv_curr  TYPE zdecur_04.

DATA: lo_exception TYPE REF TO zcx_exceptionclass2_04. "object of exception class
DATA: lv_message TYPE string. "variable for message in catch block

START-OF-SELECTION.
  WRITE: lv_odate, " when input is correct then display the data related to it
  / lv_pm,
  / lv_ta,
  / lv_curr.

AT SELECTION-SCREEN.
  TRY. " in case of wrong order number
      SELECT SINGLE odate pm ta curr
        FROM zordh_04
        INTO ( lv_odate, lv_pm, lv_ta, lv_curr )
        WHERE ono = p_ono.
      IF sy-subrc <> 0.
       RAISE EXCEPTION TYPE zcx_exceptionclass2_04
         EXPORTING
           textid = zcx_exceptionclass2_04=>zcx_exceptionclass2_04
*           previous =
           lv_order = p_ono
           .

      ENDIF.

    CATCH zcx_exceptionclass2_04 INTO lo_exception.
      CALL METHOD lo_exception->if_message~get_text
        RECEIVING
          result = lv_message.

      MESSAGE lv_message TYPE 'E'. "shows message in error form
  ENDTRY.

  TRY.
      IF p_ono IS INITIAL. " in case of no order number
        RAISE EXCEPTION TYPE zcx_exceptionclass2_04
          EXPORTING
            textid = zcx_exceptionclass2_04=>order_mandt
*           previous =
          .

      ENDIF.

    CATCH zcx_exceptionclass2_04 INTO lo_exception.
      CALL METHOD lo_exception->if_message~get_text
        RECEIVING
          result = lv_message.
      MESSAGE lv_message TYPE 'E'.
  ENDTRY.