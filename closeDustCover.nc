; Close the dust cover if enabled.
	o550 if [#<_rc_cover_mode> EQ 1]
		; Axis Mode: move along the configured axis to the open position.
		o560 if [#<_rc_cover_axis> EQ 3]
			G53 G0 A[#<_rc_cover_c_pos>]
		o560 elseif [#<_rc_cover_axis> EQ 4]
			G53 G0 B[#<_rc_cover_c_pos>]
		o560 elseif [#<_rc_cover_axis> EQ 5]
			G53 G0 C[#<_rc_cover_c_pos>]
		o560 endif
	o550 elseif [#<_rc_cover_mode> EQ 2]
		; Output Mode: Turn on the output and dwell
		G4 P0.25
		M65 P[#<_rc_cover_output>]
		G4 P[#<_rc_cover_dwell>]
		(debug, Dwell for cover)
	o550 endif
