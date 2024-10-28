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

; ******** BEGIN USER CONFIGURATION ********
; ATC Operations
; The units for your configuration: 20 = Inches, 21 = Millimeters
#<_rc_units> = 21
(debug,Units: #<_rc_units>)

; The number of pockets in your magazine.
#<_rc_pockets> = 8
(debug,Pockets: #<_rc_pockets>)

; The pocket offset for your magazine.
#<_rc_pocket_offset> = 37.93
(debug,Pocket Offset: #<_rc_pocket_offset>)

; The axis along which the magazine is aligned: 0 = X Axis, 1 = Y Axis.
#<_rc_alignment> = 0
(debug,Alignment: #<_rc_alignment>)

; The direction of travel from pocket 1 to pocket 2: 1 = Positive, -1 = Negative.
#<_rc_direction> = 1
(debug,Direction: #<_rc_direction>)

; The X an Y machine coordinate positions of pocket 1.
#<_rc_pocket_one_x> = -359.46
(debug,Pocket 1 X: #<_rc_pocket_one_x>)
#<_rc_pocket_one_y> = -34.612
(debug,Pocket 1 Y: #<_rc_pocket_one_y>)

; The Z machine coordinate positon of engagement.
#<_rc_engage_z> = -97.5
(debug,Engage Z: #<_rc_engage_z>)

; The Z machine coordinate position at which to start the spindle when loading.
#<_rc_load_spin_z> = -76
(debug,Load Spindle Start Z: #<_rc_load_spin_z>)

; The number of times to plunge when loading.
#<_rc_plunge_count> = 2
(debug,Load Plunge Count: #<_rc_plunge_count>)

; The Z machine coordinate position to rise to after unloading, before moving to load. (No Tool Loaded RV)
#<_rc_to_load_z> = -3
(debug,Move To Load Z: #<_rc_to_load_z>)

; The Z machine coordinate position to rise to after loading, before moving to meeasure.
#<_rc_to_measure_z> = -3
(debug,Move To Measure Z: #<_rc_to_measure_z>)

; The Z machine coordinate position for clearing all obstacles.
#<_rc_safe_z> = -3
(debug,Safe Clearance Z: #<_rc_safe_z>)

; The feed rate for engagement.
#<_rc_engage_feed> = 2000
(debug,Engage Feed Rate: #<_rc_engage_feed>)

; Spindle speed CCW
#<_rc_unload_rpm> = 2000
(debug,Unload RPM: #<_rc_unload_rpm>)

; Spindle speed CW
#<_rc_load_rpm> = 2000
(debug,Load RPM: #<_rc_load_rpm>)

; Manual Tool Change
; X and Y machine coordinates to move to for a manual load/unload.
#<_rc_manual_x> = -360
(debug,Manual X: #<_rc_manual_x>)
#<_rc_manual_y> = -40
(debug,Manual Y: #<_rc_manual_y>)

; Dust Cover
; The dust cover operational mode: 0 = Disabled, 1 = Axis, 2 = Output
#<_rc_cover_mode> = 2
(debug,Dust Cover Mode: #<_rc_cover_mode>)

; The axis for axis mode: 3 = A Axis, 1 = B Axis, 2 = C Axis
#<_rc_cover_axis> = 0
(debug,Dust Cover Axis: #<_rc_cover_axis>)

; The machine coordinate closed position for axis mode.
#<_rc_cover_c_pos> = 0
(debug,Dust Cover Closed Pos: #<_rc_cover_c_pos>)

; The machine coordinate open position for axis mode.
#<_rc_cover_o_pos> = 0
(debug,Dust Cover Open Pos: #<_rc_cover_o_pos>)

; The output number for output mode.
#<_rc_cover_output> = 0
(debug,Dust Cover Output: #<_rc_cover_output>)

; The time to dwell in output mode to allow the cover to fully open/close before moving.
#<_rc_cover_dwell> = 1
(debug,Dust Cover Dwell: #<_rc_cover_dwell>)

; Tool Recognition
; Tool recognition mode: 0 = Disabled-User confirmation only, 1 = Enabled
#<_rc_recognize> = 1
(debug,Tool Recognition Enabled: #<_rc_recognize>)

; IR sensor input number.
#<_rc_rec_input> = 0
(debug,Tool Recognition Input: #<_rc_rec_input>)

; Z Machine coordinate positions tool recognition.
#<_rc_zone_one_z> = -63.500
(debug,Tool Recognition Zone 1 Z: #<_rc_zone_one_z>)
#<_rc_zone_two_z> =-57.0
(debug,Tool Recognition Zone 2 Z: #<_rc_zone_two_z>)

; Tool Measurement
; Tool measurement mode: 0 = Disabled, 1 = Enabled
#<_rc_measure> = 1
(debug,Tool Measure Enabled: #<_rc_measure>)

; X and Y machine coordinate positions of the tool setter.
#<_rc_measure_x> = -96.370
(debug,Tool Measure X: #<_rc_measure_x>)
#<_rc_measure_y> = -105.0
(debug,Tool Measure Y: #<_rc_measure_y>)

; Z machine coordinate position at which to begin the initial probe.
#<_rc_measure_start_z> = -35
(debug,Tool Measure Start Z: #<_rc_measure_start_z>)

; The distance to probe in search of the tool setter for the initial probe.
#<_rc_seek_dist> = 100
(debug,Tool Measure Seek Distance: #<_rc_seek_dist>)

; The distance to retract after the initial probe trigger.
#<_rc_retract_dist> = 1

(debug,Tool Measure Retract Distance: #<_rc_retract_dist>)

; The feed rate for the initial probe.
#<_rc_seek_feed> = 100
(debug,Tool Measure Seek Feed Rate: #<_rc_seek_feed>)

; The feed rate for the second probe.
#<_rc_set_feed> = 25
(debug,Tool Measure Set Feed Rate: #<_rc_set_feed>)

; The optional reference position for TLO. This may remain at it's default of 0 or be customized.
#<_rc_tlo_ref> = 0
(debug,Tool Measure TLO Ref Pos: #<_rc_tlo_ref>)
; ********* END USER CONFIGURATION *********

; ******** BEGIN CALCULATED SETTINGS *********
; ******** DO NOT ALTER THIS SECTION *********
; Set static offsets
; These calculated offsets are consumed by RapidChange macros.
o100 if [#<_rc_units> EQ 20]
  #<_rc_z_spin_off> = 0.91
  #<_rc_z_retreat_off> = 0.47
  #<_rc_set_distance> = [#<_rc_retract_dist> + 0.04]
  (debug,Static offsets set for inches)
o100 else
  #<_rc_z_spin_off> = 23
  #<_rc_z_retreat_off> = 12
  #<_rc_set_distance> = [#<_rc_retract_dist> + 1]
  (debug,Static offsets set for millimeters)
o100 endif


; The flag indicating that the settings have been loaded into memory.
#1001 = 1
(debug,Flag Set: #1001)
(debug,RapidChange ATC Configuration Loaded)
; ******** END CALCULATED SETTINGS ***********
#<_rc_current_tool> = 0
(debug, Current tool #<_current_tool> Selected Tool #<_selected_tool> 5400 #5400)
#<_rc_tool1_offset_referenced> = 0
#<_rc_tool1_offset> = 0
G43.1 Z0
