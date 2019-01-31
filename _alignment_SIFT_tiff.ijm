//@Pradeep Rajasekhar, Monash Institute of Pharmaceutical Sciences, Australia (pradeep.rajasekhar at gmail)

//Macro  to run the plugin "Linear Stack Alignment with SIFT" on tiff files in a folder. Will save the aligned files in a folder called "Aligned Images"
//read arf file (Nikon Eclipse) or tif file
//Open image files using Bioformats 
//Run "Linear Stack Alignment with SIFT" on each of the Tiff files 
//save the file as file name_aligned'

//Clears the Results window
print ("\\Clear");
//CLose all open images
run("Close All");

//create directory lists
input = getDirectory("Choose Input Directory ");
output_path=input+"Aligned Images"+File.separator;

if (!File.exists(output_path)) //Make a directory with name Aligned images in the input directory to save the aligned images
	{
	File.makeDirectory(output_path);
	}

extension= getString("Enter the extension of the files (will not work for liff). Download the other macro.", "tif"); //can disable this by entering extension ="tif"; if you always use tif files
setBatchMode(true); //batchmode set to True
input_list = getFileList(input); //get no of files

//Close Progress bar if it is open
if(isOpen("Progress")) selectWindow("Progress"); run("Close");

//Initialise Progress Bar
title = "[Progress]";
run("Text Window...", "name="+ title +" width=50 height=3 monospaced"); //Initialise progress bar

//get Time info
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
print("Analysis started at: "+hour+":"+minute);

new_file_list=ext_file(input,input_list,extension);
Array.print(new_file_list);
//run a for loop iteratively on each file within the folder
for (i=0; i<new_file_list.length; i++) //loop through all the files in the directory
{
	path=input+new_file_list[i]; //Initialise path variable with the file path

	if (endsWith(path, extension)) //only execute following code if file ends with lif// could adapt to other microscopy formats
		{
		if(i==0) print(title, "\\Update:"+0+"/"+new_file_list.length+" ("+0+"%)\n"+getBar(0, new_file_list.length));
		run("Bio-Formats Importer", "open=["+path+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		name=getTitle();
		print("Active Image: "+name);
		//run("Slice Remover", "first=1 last=(no of last slice) increment=1"); //SIFT uses the first frame as template for alignment; IF first few frames have artefacts and mess up the alignment, remove the backslashes to activate this
		getDimensions(width, height, channels, slices, frames); //get the number of frames		
		align_sift(); //call function to align image
		wait(100);
		close(name); //close the original image
		selectWindow("Aligned "+frames+" of "+frames);	
		saveAs("Tiff", output_path+name+"_aligned"); //save the new aligned image in the same directory as 
		close(name+"_aligned.tif"); //close the alignedimage after saving it
		//update the progress bar
		print(title, "\\Update:"+(i+1)+"/"+new_file_list.length+" ("+d2s(((i+1)*100/new_file_list.length),0)+"%)\n"+getBar((i+1), new_file_list.length));
		}
}

setBatchMode(false); //batchmode set to False
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour1, minute1, second, msec);
print("Macro finished on: "+hour1+":"+minute1);
current_time=execution_time(hour,minute,hour1,minute1); //calculate the execution time of the macro; function will return hours took in first index current_time[0] and minutes in second index current_time[1]
print("Macro took: "+current_time[0]+" hour/s, "+current_time[1]+"minute/s"); //divide seconds by 3600 to conver to ho

//function to get the list of files that have the extension passed from the main code 
function ext_file(input,input_list,extension)
{
	
	setOption("ExpandableArrays", true); //automatically expand array size on the go.
	ext_file_array=newArray; //store the file list
	j=0; //initialise j as array number for th ext_file_array. Otherwise if the first file is does not have the extension and we use ext_file_array[i] instead, it will throw an error 
	for (i=0; i<input_list.length; i++) //loop through all the files in the directory
	{
		path=input+input_list[i]; //Initialise path variable with the file path
	if(endsWith (path,extension))
	{
		ext_file_array[j]=input_list[i];
		j+=1; //increase counter by 1
	}
	}
	return ext_file_array;
}

//function to run image registration; can be modified to pass parameters
//https://imagej.net/Linear_Stack_Alignment_with_SIFT
function align_sift()
{
	run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Affine interpolate");
}

//calculate the execution time based on start time and end time of Macro (in hours and minutes)
function execution_time(hour,minute,hour1,minute1)
{
	setOption("ExpandableArrays", true); //automatically expand array size on the go.
	time_elapsed=newArray;
	temp_minute=(minute1+(60-minute)); //total time in seconds
	if(temp_minute<60)
		{current_hr=hour1-hour-1;
 		 current_min=temp_minute;
		}
	else if(temp_minute>=60) 
		{ current_min=temp_minute-60;
		  current_hr=hour1-hour;
		}
	time_elapsed[0]=current_hr;
	time_elapsed[1]=current_min;
	return time_elapsed;
}



//Progress bar (https://imagej.nih.gov/ij/macros/ProgressBar.txt)
  function getBar(p1, p2) {
        n = 20;
        bar1 = "--------------------";
        bar2 = "********************";
        index = round(n*(p1/p2));
        if (index<1) index = 1;
        if (index>n-1) index = n-1;
        return substring(bar2, 0, index) + substring(bar1, index+1, n);
  }
