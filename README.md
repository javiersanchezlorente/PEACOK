# PEACOK
## Phenome Exome Association and Correlation Of Key phenotypes

This R package  re-implements, customizes and enhances the phenome scan functionlities of the original PHESANT R programs as described in https://github.com/MRCIEU/PHESANT. In this implementation, while trying to make it compatiable with the original approach, we focus on seperating phenotype matrix generation from statistical association tests and allowing statistical tests to be performed seperately on different computing envrionments, such as a high performance computing cluster or an AWS Batch envrionment. We also introduce more functionalities such as generating phenotypes for every node from a tree-like UK Biobank data code such as ICD10, or allowing user to run logistic regression on a binary phenotype with covariates.

Users are encouraged to check out the PHESANT R program first to understand the design and functionalities there. The companion R documentation PEACOK.pdf in this folder provides further details on functions implemented in the package.  We are also in the process of adding more examples to show how to use these functions.

This package is currently designed to work with UK Biobank Phenotype fields directly and some modifications/customizations will be necessaryif the input data format is different from that of UK Biobank data.

A typical use of the packages will involve the following steps.
* Prepare/update the UKB fields information file and data coding code as described in PHESANT. While user can follow the steps in PHESANT to do that, we also provided helper functions in this package to enable automatically downloading of the UKB data coding files and update an existing UKB field information file to a new release.
* Use similar options that are availavle to PHESANT phenomeScan.r script to generate phenotype matrices that can be used later on to run PheWAS/exWAS scan analysis. While similar to PHESANT, user can still run association tests directly without generating phenotype matrices explicitly, we find it more convinient when one needs to run larger analysis and need to scale the analysis up using parallel clusters or AWS batch. We also add more options to allow user to generate phenotype matrices for a given set of UKB fields or a given sub set of samples. 
* Prepare/generate genotype matrices at the gene/variant level. While this step typically is not done using PEACOK, the package provides helper functions to parse/reformat user input into formats that are either memory-efficient or compute-efficient.
* Run association tests using the genotype/phenotype matrices from previous steps and more often than not, in a distributed compute envrionment. 


## General requrements

R 3.6.1 or above is needed to use this package. Sucessful instalation of PEACOK package requires the following R packages: MASS (7.3-51.6 or above), optparse(1.6.6 or above), tidyr(1.1.0 or above), dplyr(1.0.0 or above). Some older versions might also work. 

## Folder structures

* PEACOK.pdf: the most up to date PEACOK R package documentation.
* varaible-info: This folder holds example UKB field definition file as well as the  data coding definition file  that will be used by the package. Infomation on updating and modifying these files can be found in the README.md file in coresponding sub folders. We also include all the data codes downloaded from the UK Biobank portal. The current release is 41065.
* versions: This folder will keep snapshots of each version when they are released. The companion R documentation PDF file will also be included in each sub folder. The current version of PEACOK is 1.0.7.
* PEACOK: the source code folder for the current version of the package.
* data: this folder will hold the example data sets to be used by PEACOK code examples.
* examples: this folder will give code examples demostrating the package capabilities.



