o600 if [#<_rc_measure> EQ 1 AND #<_rc_current_tool> NE [#<_rc_pockets> + 1] AND #<_rc_current_tool> NE 0]
		; Tool measure is enabled and we have a tool.
		; Is this the first measurement we are taking

		G53 G90 G0 Z[#<_rc_safe_z>]
		(debug, Move to Z safe)
		G53 G0 X[#<_rc_measure_x>] Y[#<_rc_measure_y>]
		(debug, Move to tool setter XY)
		G53 G0 Z[#<_rc_measure_start_z>]
		G4 P0.25
		(debug, 1: #5422 2: #<_rc_measure-start_z>)

		(debug, Down to Z seek start)
		G38.2 G91 Z[#<_rc_seek_dist> * -1] F[#<_rc_seek_feed>]
		(debug, Probe Z down seek mode)
		G0 G91 Z[#<_rc_retract_dist>]
		(debug, Retract from tool setter)
		G38.2 G91 Z[#<_rc_set_distance> * -1] F[#<_rc_set_feed>]
		(debug, Probe Z down set mode)
		G53 G0 G90 Z[#<_rc_safe_z>]
		(debug, Triggered Work Z: #5063)

		o620 if[#<_rc_tool1_offset_referenced> EQ 0]
			#<_rc_tool1_offset> = #5063
			#<_rc_tool1_offset_referenced> = 1
	        (debug, first tool referenced)
		o620 else
			#<_rc_trigger_mach_z> = [#5063 - #<_rc_tool1_offset>]
			(debug, 5063: #5063)
			(debug, tool1 offset #<_rc_tool1_offset>)
			(debug, Triggered Mach Z: #<_rc_trigger_mach_z>)
			G4 P0.25
			G43.1 Z[#<_rc_trigger_mach_z>]
			(debug, Ref Mach Pos: 0, Work Z after G43.1: #<_z>)
		o620 endif
	o600 else
		; Tool measure is disabled
		(debug, Tool measurement disabled)
		G53 G0 Z[#<_rc_safe_z>]
		(debug, Moved to safe clearance)
	o600 endif
