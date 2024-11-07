;
; Copyright (C) 2024 Greilick Industries LLC

; RapidChange ATC Macros for GrblHAL is free software:
; You can redistribute it and/or modify it under the terms
; of the GNU General Public License as published by
; the Free Software Foundation, under version 3 of the License.

; RapidChange ATC Macros for GrblHAL is distributed in the
; hope that it will be useful, but WITHOUT ANY WARRANTY
; without even the implied warranty of MERCHANTABILITY or
; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
; License for more details.

; You should have received a copy of the GNU General Public License
; along with RapidChange ATC Macros for GrblHAL.  
; If not, see <https://www.gnu.org/licenses/>.
;

; ************ BEGIN VALIDATION ************
o50 if [#1001 NE 1]
	(debug, RapidChange settings are not initialized.)
	(debug, Abort operation and initialize RapidChange settings.)
	(debug, Program has been paused with M0.)
	$Alarm/Send=3
o50 elseif [#<_selected_tool> LT 0]
	(debug, Selected Tool: #<_selected_tool> is out of range. Tool change aborted. Program paused.)
	$Alarm/Send=3
o50 elseif [#<_selected_tool> EQ #<_rc_current_tool>]
	(debug, Current tool selected. Tool change bypassed.)
o50 else
	(debug, Tool change validated)
	; ************* END VALIDATION *************

	; ************** BEGIN SETUP ***************
	; Turn off spindle and coolant
	M5
	M9
	(debug, Spindle and coolant turned off)

	; Record current units
	o200 if [#<_metric> EQ 0]
		#<_rc_return_units> = 20
	o200 else
		#<_rc_return_units> = 21
	o200 endif
	(debug, Units recorded)

	; Activate configured units and absolute distance mode
	G[#<_rc_units>] G90
	(debug, Set units and distance)

	; Set pocket locations
	o210 if [#<_rc_alignment> EQ 0]
		#<_rc_x_load> = [[[#<_selected_tool> - 1] * #<_rc_pocket_offset> * #<_rc_direction>] + #<_rc_pocket_one_x>]
		(debug, Load X set to #<_rc_x_load>)
		#<_rc_y_load> = #<_rc_pocket_one_y>
		(debug, Load Y set to #<_rc_y_load>)

		#<_rc_x_unload> = [[[#<_rc_current_tool> - 1] * #<_rc_pocket_offset> * #<_rc_direction>] + #<_rc_pocket_one_x>]
		(debug, Unload X set to #<_rc_x_unload>)
		#<_rc_y_unload> = #<_rc_pocket_one_y>
		(debug, Unload Y set to #<_rc_y_unload>)
		(debug, Pocket locations set for X alignment)
	o210 else
		#<_rc_x_load> = #<_rc_pocket_one_x>
		(debug, Load X set to #<_rc_x_load>)
		#<_rc_y_load> = [[[#<_selected_tool> - 1] * #<_rc_pocket_offset> * #<_rc_direction>] + #<_rc_pocket_one_y>]
		(debug, Load Y set to #<_rc_y_load>)

		#<_rc_x_unload> = #<_rc_pocket_one_x>
		(debug, Unload X set to #<_rc_x_unload>)
		#<_rc_y_unload> = [[[#<_rc_current_tool> - 1] * #<_rc_pocket_offset> * #<_rc_direction>] + #<_rc_pocket_one_y>]
		(debug, Unload Y set to #<_rc_y_unload>)
		(debug, Pocket locations set for Y alignment)
	o210 endif

	G53 G0 Z[#<_rc_safe_z>]
	(debug, Moved to safe clearance)

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
	; *************** END SETUP ****************

	; ************** BEGIN UNLOAD **************
	; Unload current tool


	o300 if [#<_rc_current_tool> EQ [#<_rc_pockets> + 1] OR #<_rc_current_tool> EQ 0 ]
		; We have tool 0. Do nothing as we are already unloaded.
		(debug, Unloaded tool 0)
	o300 elseif [#<_rc_current_tool> GT [#<_rc_pockets> + 1]]
		; Tool out of magazine range. Unload manually
		G53 G0 X[#<_rc_manual_x>] Y[#<_rc_manual_y>]
		(debug, Tool #<_rc_current_tool> is out of magazine range. Manually remove tool #<_rc_current_tool> and cycle start to continue.)
		M0
		(debug, Unloaded tool out of range)
	o300 else
		; We have a tool with a pocket
		G53 G0 X[#<_rc_x_unload>] Y[#<_rc_y_unload>]
		(debug, Move to pocket #<_rc_current_tool>)
		G53 G0 Z[#<_rc_engage_z> + #<_rc_z_spin_off>]
		(debug, Move to spin start)
		M4 S[#<_rc_unload_rpm>]
		(debug, Run spindle CCW)
		G53 G1 Z[#<_rc_engage_z>] F[#<_rc_engage_feed>]
		(debug, Engage)
		G53 G1 Z[#<_rc_engage_z> + #<_rc_z_retreat_off>] F[#<_rc_engage_feed>]
		(debug, Retreat)
	  
		; Confirm tool unloaded
		o310 if [#<_rc_recognize> EQ 1]
			G53 G0 Z[#<_rc_zone_one_z>]
			(debug, Move to zone 1)
			G4 P0.25
			M66 P[#<_rc_rec_input>] L0
			(debug, Read input: #5399)

			o320 if [#5399 EQ 0]
				(debug, Input read timed out)
				G53 G0 Z[#<_rc_engage_z> + #<_rc_z_spin_off>]
				(debug, Go to spindle start)
				G53 G1 Z[#<_rc_engage_z>] F[#<_rc_engage_feed>]
				(debug, Engage)
				G53 G1 Z[#<_rc_engage_z> + #<_rc_z_retreat_off>] F[#<_rc_engage_feed>]
				(debug, Retreat)
				M5
				G53 G0 Z[#<_rc_zone_one_z>]
				(debug, Move to zone 1)
				G4 P0.25
				M66 P[#<_rc_rec_input>] L0
				(debug, Input read again: #5399)
				o330 if [#5399 EQ 0]
					(debug, Input read timed out again)
					G53 G0 Z[#<_rc_safe_z>]
					(debug, Go to safe clearance)
					G53 G0 X[#<_rc_manual_x>] Y[#<_rc_manual_y>]
					(debug, Go to manual position)
					(debug, Tool #<_rc_current_tool> failed to unload. Please manually unload tool #<_rc_current_tool> and cycle start to continue.)
					M0
				o330 else
					G53 G0 Z[#<_rc_to_load_z>]
					(debug, Go to move to load)
				o330 endif
			o320 else
				M5
				G53 G0 Z[#<_rc_to_load_z>]
				(debug, Go to move to load)
			o320 endif
		o310 else
			M5
			(debug, Stop spindle)
			G53 G0 Z[#<_rc_to_load_z>]
			(debug, Go to move to load)
			(debug, Confirm tool #<_rc_current_tool> is unloaded and press cycle start to continue.)
			M0
		o310 endif
	o300 endif
	; *************** END UNLOAD ***************

	; *************** BEGIN LOAD ***************
	o400 if [#<_selected_tool> EQ [#<_rc_pockets> + 1] OR [#<_selected_tool> EQ 0]]
		; We selected tool 98, symbol for tool 0.
		; Go to safe z.
		G53 G0 Z[#<_rc_safe_z>]
		(debug, Moved to safe clearance)
        ; reset TLO to 0
        G43.1 Z0
        (debug, G43.1 Z offset removed)
        #<_rc_current_tool> = 0
        #<_rc_tool1_offset> = 0
        #<_rc_tool1_offset_referenced> = 0
	o400 elseif [#<_selected_tool> LE #<_rc_pockets>]
		; We have a tool with a pocket
		G53 G0 X[#<_rc_x_load>] Y[#<_rc_y_load>]
		(debug, Move to pocket #<_selected_tool>)
		G53 G0 Z[#<_rc_engage_z> + #<_rc_z_spin_off>]
		(debug, Move to spin start)
		G53 G1 Z[#<_rc_load_spin_z>] F[#<_rc_engage_feed>]
		M3 S[#<_rc_load_rpm>]
		(debug, Run spindle CW)

		#<_rc_times_plunged> = 0
		o410 while [#<_rc_times_plunged> LT #<_rc_plunge_count>]
			G53 G1 Z[#<_rc_engage_z>] F[#<_rc_engage_feed>]
			(debug, Engage)
			G53 G1 Z[#<_rc_engage_z> + #<_rc_z_retreat_off>] F[#<_rc_engage_feed>]
			(debug, Retreat)
			#<_rc_times_plunged> = [#<_rc_times_plunged> + 1]
			(debug, Load plunge #<_rc_times_plunged> complete)
		o410 endwhile

		M5
		(debug, Stop spindle)

		; Confirm Load
		o420 if [#<_rc_recognize> EQ 1]
			(debug, Tool Recognition Enabled)
			G53 G0 Z[#<_rc_zone_one_z>]
			(debug, Move to zone 1)
			G4 P0.25
			M66 P[#<_rc_rec_input>] L0
			(debug, Read input: #5399)

			o430 if [#5399 EQ 1]
				(debug, Failed Zone 1)
				G53 G0 Z[#<_rc_safe_z>]
				(debug, Moved to safe clearance)
				G53 G0 X[#<_rc_manual_x>] Y[#<_rc_manual_y>]
				(debug, Tool #<_selected_tool> failed to load zone 1. Manually load tool #<_selected_tool> and cycle start to continue.)
				M0
				(debug, Manually loaded tool after failure)
			o430 else
				(debug, Passed Zone 1)
				G53 G0 Z[#<_rc_zone_two_z>]
				(debug, Move to zone 2)
				G4 P0.25
				M66 P[#<_rc_rec_input>] L0
				(debug, Read input: #5399)
				o440 if [#5399 EQ 0]
					G53 G0 Z[#<_rc_safe_z>]
					(debug, Moved to safe clearance)
					G53 G0 X[#<_rc_manual_x>] Y[#<_rc_manual_y>]
					(debug, Tool #<_selected_tool> failed to load Zone 2. Manually load tool #<_selected_tool> and cycle start to continue.)
					M0
					(debug, Manually loaded tool after failure)
				o440 else
					G53 G0 Z[#<_rc_to_measure_z>]
					(debug, Move to measure z)
				o440 endif
			o430 endif
		o420 else
			(debug, Tool recognition disabled)
			G53 G0 Z[#<_rc_to_measure_z>]
			(debug, Move to measure z)
			(debug, Confirm tool #<_selected_tool> is loaded and press cycle start to continue.)
			M0
		o420 endif
	o400 else
		; Tool out of magazine range. Load manually
		G53 G0 X[#<_rc_manual_x>] Y[#<_rc_manual_y>]
		(debug, Tool #<_selected_tool> is out of magazine range. Manually load tool #<_selected_tool> and cycle start to continue.)
		M0
		(debug, Loaded tool out of range)
	o400 endif

	; Update the current tool.
	; M61 Q[#<_selected_tool>]
	; update _rc_current_tool to be _selected tool
	#<_rc_current_tool> = #<_selected_tool>
	G4 P0.25
	(debug, Loaded tool #<_rc_current_tool>)
	; *************** END LOAD *****************

	; ************* BEGIN MEASURE **************

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
	; ************* END MEASURE ****************

	; ************ BEGIN TEARDOWN **************
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

	; Restore units
	G[#<_rc_return_units>]
	(debug, Units restored)
	(debug, Tool change complete)


o50 endif
; ************* END TEARDOWN ***************
