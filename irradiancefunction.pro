Pro irradianceFunction

restore,'/Users/lokidog/Documents/idl/data/sample_xrs_data.sav'

  p = PLOT(d.YCLEAN[*,0], "r4D-", YTITLE='Resistance ($\Omega$)', $
    TITLE="Circuit Resistance", DIM=[450,400], MARGIN=0.2)

  ; Set some properties
  p.SYM_INCREMENT = 5
  p.SYM_COLOR = "blue"
  p.SYM_FILLED = 1
  p.SYM_FILL_COLOR = 0

End