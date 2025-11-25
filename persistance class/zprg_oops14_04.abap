*&---------------------------------------------------------------------*
*& Report ZPRG_OOPS14_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_oops14_04.

DATA: lo_obj TYPE REF TO zcl_perstclass1_04.
DATA: lo_agent TYPE REF TO zca_perstclass1_04.
DATA: lv_ono TYPE zdeono_04.
DATA: lv_odate TYPE zdeodate_04.
DATA: lv_pm TYPE zdepm_04.
DATA: lv_ta TYPE zdetc_04.
DATA: lv_curr TYPE zdecur_04.

PARAMETERS: p_ono   TYPE zdeono_04 OBLIGATORY,
            p_odate TYPE zdeodate_04,
            p_pm    TYPE zdepm_04,
            p_ta    TYPE zdetc_04,
            p_curr  TYPE zdecur_04.

PARAMETERS: p_r1 TYPE c RADIOBUTTON GROUP r1,
            p_r2 TYPE c RADIOBUTTON GROUP r1,
            p_r3 TYPE c RADIOBUTTON GROUP r1.

START-OF-SELECTION.
*Insertion logic
  IF p_r1 = 'X'.

    lo_agent = zca_perstclass1_04=>agent.
    TRY.
        CALL METHOD lo_agent->create_persistent "method for creating new order number
          EXPORTING
            i_ono  = p_ono
          RECEIVING
            result = lo_obj.
      CATCH cx_os_object_existing.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_odate "sets order date
          EXPORTING
            i_odate = p_odate.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_pm "sets payment mode
          EXPORTING
            i_pm = p_pm.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_ta "sets total amount
          EXPORTING
            i_ta = p_ta.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_curr "sets currency
          EXPORTING
            i_curr = p_curr.
      CATCH cx_os_object_not_found.
    ENDTRY.

    COMMIT WORK. "explicit commiting for inserting data into database table
    IF sy-subrc = 0.
      MESSAGE i011(zmessage_04).
    ENDIF.
*  Updation logic
  ELSEIF p_r2 = 'X'.
    TRY.
        CALL METHOD lo_agent->get_persistent "method for getting existing order number
          EXPORTING
            i_ono  = p_ono
          RECEIVING
            result = lo_obj.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_odate "sets order date
          EXPORTING
            i_odate = p_odate.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_pm "sets payment mode
          EXPORTING
            i_pm = p_pm.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_ta "sets total amount
          EXPORTING
            i_ta = p_ta.
      CATCH cx_os_object_not_found.
    ENDTRY.

    TRY.
        CALL METHOD lo_obj->set_curr "sets currency
          EXPORTING
            i_curr = p_curr.
      CATCH cx_os_object_not_found.
    ENDTRY.

    COMMIT WORK. "explicit commiting for updating the database table
    IF sy-subrc = 0.
      MESSAGE i012(zmessage_04).
    ENDIF.
* Deletion logic
  ELSEIF p_r3 = 'X'.

    TRY.
        CALL METHOD lo_agent->delete_persistent "deletes the existing order number
          EXPORTING
            i_ono = p_ono.
      CATCH cx_os_object_not_existing.
    ENDTRY.

    COMMIT WORK. "explicit commiting for deleting record in database tables
    IF sy-subrc = 0.
      MESSAGE i013(zmessage_04).
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN.
* insert validation logic
  IF p_r1 = 'X'.

*  SELECT SINGLE ono
*    FROM zordh_04
*    INTO lv_ono
*    WHERE ono = p_ono.
*  IF sy-subrc = 0.
*    MESSAGE e009(zmessage_04) WITH p_ono.
*  ENDIF.
    CLEAR: lo_agent, lo_obj.
    lo_agent = zca_perstclass1_04=>agent. "fetching object of agent class

    TRY.
        CALL METHOD lo_agent->get_persistent
          EXPORTING
            i_ono  = p_ono
          RECEIVING
            result = lo_obj.
      CATCH cx_os_object_not_found.
    ENDTRY.

    IF lo_obj IS NOT INITIAL.
      MESSAGE e009(zmessage_04) WITH p_ono.
    ENDIF.

* update validation logic
  ELSEIF p_r2 = 'X'.
    CLEAR: lo_agent, lo_obj.
    lo_agent = zca_perstclass1_04=>agent.

    TRY.
        CALL METHOD lo_agent->get_persistent
          EXPORTING
            i_ono  = p_ono
          RECEIVING
            result = lo_obj.
      CATCH cx_os_object_not_found.
    ENDTRY.

    IF lo_obj IS INITIAL.
      MESSAGE e010(zmessage_04) WITH p_ono.

    ELSEIF lo_obj IS NOT INITIAL.
      TRY.
          CALL METHOD lo_obj->get_odate "fetches order date
            RECEIVING
              result = lv_odate.
        CATCH cx_os_object_not_found.
      ENDTRY.

      TRY.
          CALL METHOD lo_obj->get_pm "fetches payment mode
            RECEIVING
              result = lv_pm.
        CATCH cx_os_object_not_found.
      ENDTRY.

      TRY.
          CALL METHOD lo_obj->get_ta " fetches total amount
            RECEIVING
              result = lv_ta.
        CATCH cx_os_object_not_found.
      ENDTRY.

      TRY.
          CALL METHOD lo_obj->get_curr "fetches currency
            RECEIVING
              result = lv_curr.
        CATCH cx_os_object_not_found.
      ENDTRY.
    ENDIF.

* delete validation logic
  ELSEIF p_r3 = 'X'.

    CLEAR: lo_agent, lo_obj.
    lo_agent = zca_perstclass1_04=>agent.

    TRY.
        CALL METHOD lo_agent->get_persistent
          EXPORTING
            i_ono  = p_ono
          RECEIVING
            result = lo_obj.
      CATCH cx_os_object_not_found.
    ENDTRY.

    IF lo_obj IS INITIAL.
      MESSAGE e010(zmessage_04) WITH p_ono.
    ENDIF.

  ENDIF.

AT SELECTION-SCREEN OUTPUT.
  IF p_r2 = 'X'. " to bind the variable's value with the screen fields and display them
    p_odate = lv_odate.
    p_pm = lv_pm.
    p_ta = lv_ta.
    p_curr = lv_curr.
  ENDIF.