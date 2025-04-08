# FluidNC M6_Macro implementation for RapidChangeATC

> :warning: **Usage at your own risk, was only roughly tested on my machine**

REQUIREMENTS: FluidNC 3.9.5 (This will be the version that has the needed fixes to properly support this code)
- There were some bugs found that are corrected in this version.
- Now uses the implemented _current_tool instead of our own _rc_current_tool

This is a conversion of the GRBLHal Script.  

- Edit the init.nc script to match your setup. 
- The init.nc script only needs to be run once after startup / reset
- You can create a macro button to run the init.nc or set it as startup_line0 macro. If you decide to go with the startup script you will need to make sure must_home is set false or it will not run.
- ~~FluidNC does not pass tool 0 to the m6_macro.  As a work around, if you have X pockets, X+1 will be used to unload the tool. (ie 8 Pocket ATC, tool nine will unload the tool )~~ This has been fixed in 3.9.2
- The spindle being used with the toolchanger will need to be your first tool
- Any tool number over your total number of pockets and less then the next spindles tool number will be treated as a manual tool change

You will need to define a input and output and add it to the Yaml as well
```
user_outputs:
  digital0_pin:  gpio.25:LOW ; Pin for Dust Cover
user_inputs:
  digital0_pin:  GPIO.16:LOW ; Pin for tool setter
```
