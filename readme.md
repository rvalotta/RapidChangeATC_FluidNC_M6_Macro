FluidNC M6_Macro implementation for RapidChangeATC

REQUIREMENTS: FluidNC 3.8.4-Pre7
- There were some bugs found that are corrected in this version.

This is a conversion of the GRBLHal Script.  

- Edit the init.nc script to match your setup. 
- The init.nc script only needs to be run once
- You can create a macro button to run the init.nc or set it as startup_line0 macro. If you decide to go with the startup script you will need to make sure must_home is set false or it will not run.
- FluidNC does not pass tool 0 to the m6_macro.  As a work around, if you have X pockets, X=1 will be used to unload the tool. (ie 8 Pocket ATC, tool nine will unload the tool )
- The spindle being used with the toolchanger will need to be your first tool
