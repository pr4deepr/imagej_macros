//Macro for renaming ROIs in sequential order with user entered label
//Select the first and last ROIs, enter the label you want and it will be renamed accordingly.

waitForUser("Start ROI", "Select first ROI for renaming and click OK.");
start=roiManager("index");
waitForUser("End ROI", "Select last ROI for renaming and click OK.");
end=roiManager("index");
name=getString("Enter label you want for the cell", "Mac");
z=1;
for (i=start; i<=end;i++){ 
	roiManager("Select", i);
	roiManager("Rename", name+"_"+z);
	z+=1;
}
