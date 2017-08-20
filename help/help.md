### A step-by-step guide to use DeepCC Online

<br>  

#### Step 1. Covert uploaded gene expression data to functional spectra  
(*Skip this step if you want to use public data available)

##### (1) Upload your gene expression data. Please click the Browse button and chose your local file containing gene expression profiles (in csv format), where columns are samples and rows are genes.
  
<br>  

<img src="./01.PNG" width = "500"/>

<br>  

##### (2) After uploading, check the status of data uploading/processing.

<br>  

<img src="./02.PNG" width = "700"/>

<br> 

##### (3) Specify gene annotation, gene set database (currently only MSigDBv6 is provided), and whether the platform is two-color microarray

<br>  

<img src="./03.PNG" width = "500"/>

<br> 

##### (4) Click ‘Calculate Functional Spectra’ button to transform uploaded gene expression data to functional spectra. You can also check the status to confirm.

 
#### Step 2. Prediction using uploaded data  

##### (1) Select the specific cancer type.  

##### (2) Select which pretrained classifier to use.  

##### (3) Select functional Spectra calculated from ‘uploaded’ data or preprocessed public data sets.

<br>  

<img src="./04.PNG" width = "500"/>

<br> 

##### (4) Specify the cutoff on posterior probability.  

<br>  

<img src="./05.PNG" width = "500"/>

<br> 

##### (5) Click ‘Predict Cancer Subtype’ for classification  

The predicted results will appear on the right side of the page, and can be downloaded in various formats (csv, excel, pdf). 

<br>  

<img src="./06.PNG" width = "800"/>

<br> 

