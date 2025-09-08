  METHOD get_data.

    DATA: lt_vbak  TYPE TABLE OF lty_vbak,
          lwa_vbak TYPE lty_vbak.

    DATA: lt_vbap  TYPE TABLE OF lty_vbap,
          lwa_vbap TYPE lty_vbap.

    DATA: lwa_output TYPE lty_output.

    SELECT vbeln erdat erzet ernam vbtyp
      FROM vbak
      INTO TABLE lt_vbak
      WHERE vbeln IN svbeln.

    IF lt_vbak IS NOT INITIAL.
      SELECT vbeln posnr matnr
        FROM vbap
        INTO TABLE lt_vbap
        FOR ALL ENTRIES IN lt_vbak
        WHERE vbeln = lt_vbak-vbeln.
    ENDIF.

    LOOP AT lt_vbak INTO lwa_vbak.
      LOOP AT lt_vbap INTO lwa_vbap where vbeln = lwa_vbak-vbeln.
        lwa_output-vbeln = lwa_vbak-vbeln.
        lwa_output-erdat = lwa_vbak-erdat.
        lwa_output-erzet = lwa_vbak-erzet.
        lwa_output-ernam = lwa_vbak-ernam.
        lwa_output-vbtyp = lwa_vbak-vbtyp.
        lwa_output-posnr = lwa_vbap-posnr.
        lwa_output-matnr = lwa_vbap-matnr.
        APPEND lwa_output TO lt_output.
        CLEAR: lwa_output.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.