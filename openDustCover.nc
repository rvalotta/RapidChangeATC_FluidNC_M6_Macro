	; Open the dust cover if enabled.
	o500 if [#<_rc_cover_mode> EQ 1]
		; Axis Mode: move along the configured axis to the open position.
		o510 if [#<_rc_cover_axis> EQ 3]
			G53 G0 A[#<_rc_cover_o_pos>]
		o510 elseif [#<_rc_cover_axis> EQ 4]
			G53 G0 B[#<_rc_cover_o_pos>]
		o510 elseif [#<_rc_cover_axis> EQ 5]
			G53 G0 C[#<_rc_cover_o_pos>]
	  o510 endif
	o500 elseif [#<_rc_cover_mode> EQ 2]
	  ; Output Mode: Turn on the output and dwell
	  G4 P0.25
	  M64 P[#<_rc_cover_output>]
	  G4 P[#<_rc_cover_dwell>]
	o500 endif