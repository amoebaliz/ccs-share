# Shared repository for setting up and running MOM6-CCS

*The content and organizational structure herein are based on Andrew C. Ross's nwa-share repository*

We recommend referencing the [MOM6-examples wiki](https://github.com/NOAA-GFDL/MOM6-examples/wiki) while setting up this regional simulation. 

## Demo Run

1. Generate initial and boundary condition files. 
2. Download JRA atmospheric forcing using ```wget -i run/jra_urls.txt``` and place the files in ```run/INPUT/```
The model will crash due to the long length of the comment attribute in the RLDS file. To fix, ```ncatted -O -a comment,rlds,d,, rlds_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-5-0_gr_198001010130-198012312230.nc```
3. Create a job script and submit.
   - The demo is set to use 265 (10x30 - 35 masked) processors but this can be modified
   - Layout modifications are made in ```run/input.nml```,```run/MOM_layout```, and ```run/SIS_layout```; if using a processor mask, ```run/INPUT/MOM_mask_table```, it will have to be regenerated to match the layout configuration.
 

