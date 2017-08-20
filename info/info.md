## Welcome to DeepCC online

### What is DeepCC?  

DeepCC (**D**eep **C**ancer subtype **C**lassification) is a versatile cancer subtyping framework based on deep learning of functional spectra quantifying activities of biological pathways. DeepCC takes as input high-throughput gene expression data and transforms to functional spectra based on gene set enrichment analysis. The functional spectra are subsequently input to a deep neural network trained on a reference data set (e.g., TCGA) for cancer subtype classification.  

### Which cancer types are supported?

The current version provides pretrained classifiers and public data sets for 4 cancer types involving 32 cohorts totaling 9763 samples altogether (Details in the following table). 

<table>
<col width="100">
<col width="100">
<col width="100">
<col width="100">
<col width="300">
 <thead>
  <tr>
   <th style="text-align:center;"> Cancer type </th>
   <th style="text-align:center;"> Total # of cohorts </th>
   <th style="text-align:center;"> Total # samples </th>
   <th style="text-align:center;"> Training cohort </th>
   <th style="text-align:left;"> Reference </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Colon cancer </td>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 3578 </td>
   <td style="text-align:center;"> TCGA </td>
   <td style="text-align:left;"> Guinney, J. et al. The consensus molecular subtypes of colorectal cancer. Nat. Med. (2015). doi:10.1038/nm.3967 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Breast cancer </td>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 4148 </td>
   <td style="text-align:center;"> TCGA </td>
   <td style="text-align:left;"> Parker, J. S. et al. Supervised risk predictor of breast cancer based on intrinsic subtypes. J. Clin. Oncol. 27, 1160–1167 (2009). </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ovarian cancer </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 1077 </td>
   <td style="text-align:center;"> MAYO </td>
   <td style="text-align:left;"> Konecny, G. E. et al. Prognostic and therapeutic relevance of molecular subtypes in high-grade serous ovarian cancer. J. Natl. Cancer Inst. 106, (2014). </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Gastric cancer </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 960 </td>
   <td style="text-align:center;"> ARCG </td>
   <td style="text-align:left;"> Cristescu R, Lee J, Nebozhyn M, Kim KM et al. Molecular analysis of gastric cancer identifies subtypes associated with distinct clinical outcomes. Nat Med2015 May;21(5):449-56. PMID: 25894828 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Total </td>
   <td style="text-align:center;"> 32 </td>
   <td style="text-align:center;"> 9763 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
</tbody>
</table>



### How to use DeepCC Online platform?  

A detailed step-by-step guide is available on page ‘Help’. Brief instructions are as follows:  

- To use provided public data sets  
Pre-processed data sets are available for each cancer type. More details about available public data sets can be found on page ‘Analysis’.

- To use your own data
First, upload and convert your gene expression data to functional spectra on page ‘Analysis’ -> Step 1: Functional Spectra Transformation. Second, predict the molecular subtypes on page ‘Analysis’ -> Step 2: Cancer Subtype Classification. 

- As a simple DEMO, example files are provided here: [A small data set](example.csv), [A single sample](example_single.csv).

### Contact

For any feedback about the online system, please contact xin.wang@cityu.edu.hk. Please report any technical problem about problem on DeepCC's GitHub page, https://github.com/CityUHK-CompBio/DeepCC/issues


