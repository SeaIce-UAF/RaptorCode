# **Photogrammetry Metadata Pre-processor**

This script, metadata\_processor.py, is designed to clean, adjust, and prepare drone or aerial photogrammetry metadata files for photogrammetry software Pix4D.  
The transformations are crucial for ensuring correct orientation and positional accuracy when processing images into 3D models.

## **Features**

This script performs the following core data preparation steps:

1. **File Reading:** Reads the specified input CSV file containing geospatial and gimbal data.  
2. **Pitch Correction:** Corrects the GimbalPitchDegree by adding 90∘ (e.g., converting from a camera-down-relative pitch to a standard absolute pitch angle).  
3. **Roll and Yaw Normalization:** Adjusts GimbalRollDegree and GimbalYawDegree by subtracting 180∘ when the absolute roll exceeds 90∘ to maintain consistent angular ranges.  
4. **Accuracy Injection:** Adds estimated positional accuracy columns (AccuracyX, AccuracyY, AccuracyZ) to the dataset, setting them to a fixed value of 0.2 meters (configurable).  
5. **Output Generation:** Saves the processed data to a new CSV file with the \_Pix4D.csv suffix.

## **Configuration**

Before running the script, you **must** configure the file path variables within the Python script itself to point to your input data.  
Open the script and modify the following lines:

### **1\. File Path Variables**

| Variable | Description | Current Value in Script |
| :---- | :---- | :---- |
| name | The filename of your metadata CSV. | metadataPerchMergedGeoRef.csv |
| path | The absolute path to the directory containing the file. | G:\\My Drive\\myISOSP2\\2025March\_ISOPS2\_LEM\\data\\Photogrammetry |

### **2\. Accuracy Estimates**

The estimated positional accuracies for X, Y, and Z axes are currently set to 0.2 meters. Adjust these values if your equipment provides different estimates:  
AccX=0.2  \# accuracy in x direction estimate  
AccY=0.2  \# accuracy in y direction estimate  
AccZ=0.2  \# accuracy in z direction estimate

## **Output**

The script generates a new CSV file in the same directory as the input file.

* **Input File:** \[path\]/metadataPerchMergedGeoRef.csv  
* **Output File:** \[path\]/metadataPerchMergedGeoRef\_Pix4D.csv

This output file is ready to be imported into photogrammetry processing software.
