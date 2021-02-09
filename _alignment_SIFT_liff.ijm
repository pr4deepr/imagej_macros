//Macro (batchmode) to run the plugin "Linear Stack Alignment with SIFT" on liff files in a folder
//read files in a liff  file ; (Acquired from Leica microscope)
//Extract the timeseries files which have atleast more than 10 frames
//Run "Linear Stack Alignment with SIFT" on each of the Tiff files 
//save the file, series name_aligned'
//Note: if more than one channel per tiff file, it will only run alignment on the first channel

//Clears the Results window
print ("\\Clear");

//function to run image registration; can be modified to pass parameters
function align_sift()
{
	run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Affine interpolate");
}


run("Bio-Formats Macro Extensions");//can use macro extensions (Ext.) for working with lif files and the tif files within it

//create directory lists
input = getDirectory("Choose Input Directory ");
setBatchMode(true); //batchmode set to True
input_list = getFileList(input); //get no of files

//run a for loop iteratively on each file within the folder
for (i=0; i<input_list.length; i++)
{
	path=input+input_list[i];
	if (endsWith(path, ".lif")) //only execute following code if file ends with lif// could adapt to other microscopy formats
		{
			print(path);
			Ext.setId(path); //set file id to the desired lif file to access it
			Ext.getSeriesCount(seriesCount); //no of files in the lif
			print("series count= "+seriesCount);
			for (s=1; s<=seriesCount; s++) //need to set it to start from 1 as the bioformats importer only recognises from 1 onwards and not 0
			{
				run("Bio-Formats Importer", "open=["+path+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_"+s);
				name=getTitle();
				print(name);
				//setSeries will set a corresponding series within the liff file as active, so it can be accessed
				//confusingly enough, setSeries starts from 0 onwards, so for Series 1, it has to be setSeries(0); 
				Ext.setSeries(s-1);

				//get number of frames
				Ext.getSizeT(sizeT);
				print(sizeT);
				if(sizeT>10) //only if it has greater than 10 frames
				{
					print(s," ",sizeT);
					print("YES: "+name);
					Ext.getSizeC(sizeC);
					if(sizeC>1) //if there are more than one channels, it will only work on channel 1
					{
						//Split channel, discard channel 2 and keep channel 1
						print(name+" RED");
						run("Split Channels");
						wait(500);
						close("C2-"+name);//assuming first channel is calcium data/FLuo8
						selectWindow("C1-"+name);
						//Split channel, run Linear alignment on one channel and then on the other
						align_sift();
						wait(500);
						close("C1-"+name);
						selectWindow("Aligned "+sizeT+" of "+sizeT);	
						print("Saving"+input+name+"_aligned");	
						saveAs("Tiff", input+name+"_aligned");
						close(name+"_aligned.tif");
				
					}
					else
					{
						selectWindow(name);
						align_sift();
						wait(500);
						close(name);
						selectWindow("Aligned "+sizeT+" of "+sizeT);
						print("Saving"+input+name+"_aligned");
						saveAs("Tiff", input+name+"_aligned");
						close(name+"_aligned.tif");
					}
				}
				else{ print("No time series "+"Series: "+s); close(name);}
				call("java.lang.System.gc"); //garbage collector
			}

		}
		else //if file does not end with .liff
			{
			print("skipping "+path+"as it is not an image file");
			}
}
print("DONE");
Ext.close();
setBatchMode(false);
