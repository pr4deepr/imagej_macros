# Imagej Macros
  Collection of ImageJ macros that I have written or modified for my own purposes
  Many of these are inspired from stackoverflow, ImageJ forums and from other websites..
  This will be updated on the fly.
 
## Temporal color code_std_dev.ijm
 
The original macro is in ImageJ->HyperStacks, but I modified the code (added a line) where it gives an extra option for STandard deviation for maximum projection. This gets rid of a lot of noise and makes the changes much more obvious in some images. 
Original reference: https://imagej.net/Temporal-Color_Code

## Rename_ROIs.ijm

This is a simple macro to Rename ROIs in a sequential order using user defined prefix. This helps when working with tissues (different celltypes; or mixed cell cultures)
Example: If you want to label the different ROIs: Glia_1, Glia_2, Glia_3....Glia_60; 
Run the macro
Select the first ROI to be labelled, click OK
select the last ROI, Click OK
Enter the text, i.e., for Glia_1, just enter Glia, Click OK
It automatically renames all the cells within the selection range.
You can modify this by adding an extra for loop based on the celltypes that need to be labelled.
