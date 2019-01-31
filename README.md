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

## _alignment_SIFT_liff.ijm

Image registration or alignment of stacks in a folder
This macro reads in a folder containing liff files (Acquired from a Leica microscope) and implements the "Linear Stack Alignment with SIFT" plugin. It is meant to be used on timeseries data, so will only work on files (series) within the liff with greater than or equal to 10 frames. Its runs in batch mode and saves the file as file name+series name_aligned.tiff.

For Linear Stack Alignment with SIFT, it uses the following parameters:
* initial_gaussian_blur=1.60
* steps_per_scale_octave=3
* minimum_image_size=64
* maximum_image_size=1024
* feature_descriptor_size=4
* feature_descriptor_orientation_bins=8
* closest/next_closest_ratio=0.92
* maximal_alignment_error=25
* inlier_ratio=0.05
* expected_transformation=Affine

The parameters can be changed in the align_sift() function.

Note: If there is more than one channel per tiff file, it will only run the alignment on the first channel. I have implemented some code in Python, where it can run the SIFT alignment on one channel, extract the parameters and apply the transformation to the tiff stack of the second channel. Will upload it in the future..

## _alignment_SIFT_tiff.ijm
Image registration or alignment of tiff files in a folder.
Same as above, but can be used on a folder of tiff files. This macro saves it in a folder named "Aligned images" and also has a progress bar indicating the status of the analysis.

