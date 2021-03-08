# CBCR: A Curriculum Based Strategy For Chromosome Reconstruction

**OluwadareLab,**
**University of Colorado, Colorado Springs**

----------------------------------------------------------------------
**Developers:** <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Van Hovenga<br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Department of Mathematics <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;University of Colorado, Colorado Springs <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email: vhovenga@uccs.edu <br /><br />

**Contact:** <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oluwatosin Oluwadare, PhD <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Department of Computer Science <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;University of Colorado, Colorado Springs <br />
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email: ooluwada@uccs.edu 
    
--------------------------------------------------------------------	

**1.	Content of folders:**
-----------------------------------------------------------	
* src: Matlab source code. <br />
* _structures: Output structions generated from the GM12878 cell line at four different resolutions (1Mb, 500Kb, 250Kb, 100Kb).<br />

**2.	Hi-C Data used in this study:**
-----------------------------------------------------------
In our study, we used the synthetic dataset from [Adhikari, et al](https://doi.org/10.1186/s12864-016-3210-4). The contact maps, the original models and their reconstructed models used in this study were downloaded from [here](http://sysbio.rnet.missouri.edu/bdm_download/chromosome3d/unzipped/Input/Synthetic/). We also used the synthetic dataset from [Zou, et al](https://doi.org/10.1186/s13059-016-0896-1) which can be downloaded from [here](https://people.umass.edu/ouyanglab/hsa/index.html).

The GM12878 cell Hi-C dataset, GEO Accession number GSE63525, was downloaded from [GSDB](http://sysbio.rnet.missouri.edu/3dgenome/GSDB/details.php?id=GM12878) with GSDB ID: OO7429SF

**3.	Input file format:**
-----------------------------------------------------------
CBCR allows two input formats:

* Square matrix input format: A square matrix of size N by N consisting of intra-chromosomal contact matrix derived from Hi-C data, where N is the number of equal-sized regions of the chromosome.
* Tuple input format: A hi-C contact file, each line contains 3 numbers (separated by a space) of a contact, position_1 position_2 interaction_frequencies.

**4.	Usage:**
----------------------------------------------------------- 
Usage: To use, type in the terminal CBCR(input, learning_rate, conversion, max_iter_0, max_iter_1, verbose)<br /> 	
                           		
                              
* **Arguments**: <br />	
	* input: A string for the path of the input file <br />
	* learning_rate: The learning rate of the algorithm [Recommended value: .2].<br />
	* conversion: Vector or scalar. The factor(s) used to convert IF to distance, distance = 1/(IF^factor). **When a vector is used**, a structure is generated at every conversion factor in the vector and the value which maximizes the distance Spearman correlation coefficient is selected as the representitve structure. For example, if the input is [.1, .3, .5, .7,.9, 1, 1.3, 1.5], then CBCR generates a structure for each value and selects whichever one that maximizes dSCC as the representitave structure. A vector input is recommended for a thorough search. **When a vector is used**, user only needs to provide a single value, For example, an input value of 0.5 <br />
	* max_iter_0:  The maximum total number of iterations over all sub-curricula combined. This value should be smaller for smaller inputs, and larger for larger inputs. A value of 1,000 was used for the 1Mb and 500Kb, and 10,000 for the 250Kb and 100Kb resolutions in this study on the GM12878 input data <br />
	* max_iter_1: The maximum total number of iterations over the final training of CBCR if early convergence is met. A value of 500 was used for the 1Mb and 500Kb, and a value of 1,000 was used for the 250Kb and 100Kb resolutions in this study on the GM12878 input data. <br />
	* verbose: Integer. Controls the output of CBCR in the console. A value of 0 will display only the current curricula. A value of 1 will display the current curricula and each iteration with the corresponding loss, and value for alpha and beta. A value of 2 will display the outputs of verbose = 1 and a plot that displays the evolution of the chromosome as training progresses. Note that this option will slow down CBCR.<br />
	
**6.	Output:**
-----------------------------------------------------------
CBCR outputs three files: 

1. .pdb: The protein data bank file of the representative structure.
2. .log: A log file that tells the input file, the optimal structure file name, the optimal conversion factor, and the corresponding dSCC, sPCC, and dRMSE.
3. _coordinate_mapping.txt: contains the mapping of genomic positions to indices in the model. Notice that indices start from 0, while in pyMol or Chimera, id starts from 1
