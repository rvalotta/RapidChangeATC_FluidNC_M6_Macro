FluidNC M6_Macro implementation for RapidChangeATC

> :warning: **Usage at your own risk, was only roughly tested on my machine**

REQUIREMENTS: FluidNC 3.8.4-Pre7
- There were some bugs found that are corrected in this version.

This is a conversion of the GRBLHal Script.  

- Edit the init.nc script to match your setup. 
- The init.nc script only needs to be run once after startup / reset
- You can create a macro button to run the init.nc or set it as startup_line0 macro. If you decide to go with the startup script you will need to make sure must_home is set false or it will not run.
- FluidNC does not pass tool 0 to the m6_macro.  As a work around, if you have X pockets, X=1 will be used to unload the tool. (ie 8 Pocket ATC, tool nine will unload the tool )
- The spindle being used with the toolchanger will need to be your first tool
- Any tool number over your unload tool will be treated as a manual tool change
