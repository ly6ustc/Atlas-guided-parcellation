# Atlas-guided-parcellation(AGP)
A functionally-homogenous individual parcellation based on prior atlas 

Using AGP for individualized cortical parcellation, see [Atlas-guided parcellation: Individualized functionally-homogenous parcellation in cerebral cortex](https://www.sciencedirect.com/science/article/pii/S0010482522007867) for more details.

# Introduction

Using AGP for individualized cortical parcellation

In ./Atlas dir, showes classical 7 atlases to guided the individual parcellations, you can add the new prior atlases here, by yourself.

In ./code dir, includes the AGP codes and its dependency package.

In ./sample dir, provide a examplar of HCP including the rs-fMRI images(functional connectivity) and parcellation results.

# How to run
Download the entire "Atlas-guided-parcellation" directory into your PC, and download the input files of the examplar from the https://osf.io/7c62s/.

Then, enter ./code dir and run "Parcellation_main.m" or "Parcellation_main_T.m" in the ./code dir, and obtain the results in ./sample/Results/AGP/ dir.

The "Parcellation_main_T.m" is for preprocessed fMRI images in fsLR_32K surface space. The computational time decreased with the number of parcels and increased with the length of time course. About 5 minutes for the whole cerebral cortex (200 parcels) and 1200 time points, and about 2 minutes for the whole cerebral cortex (400 parcels) and 200 time points. 

The "Parcellation_main.m" is for functional connectivity files of preprocessed fMRI images in fsLR_32K surface space, About 2 minutes for the whole cerebral cortex (200 parcels) and 1200 time points. 


## Data
This method can used for fMRI images or their fucntional connectivity.

In current defalt setting:

1) fMRI images

  Date should be in this directory structure: ./sample/Timecourse/sub-xxx/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii. You can revised this directory         structure in "Parcellation_main_T.m", as follows:

![image](https://user-images.githubusercontent.com/69618541/192277363-e7d23d02-f627-4cdf-bb22-ab58ff909fdd.png)

![image](https://user-images.githubusercontent.com/69618541/192277498-f6b2cd45-a365-4af7-98a8-0b7391eb7c88.png)

2) functional connectivity

  Left date should be in this directory structure: ./sample/Connectivity/sub-xxx/FC_left_REST1.npy, and right dataYou can revised this directory structure in this       directory structure: ./sample/Connectivity/sub-xxx/FC_right_REST1.npy. You can revised this directory structure in "Parcellation_main.m", as follows:

![image](https://user-images.githubusercontent.com/69618541/192278231-ac29b8ca-c2a1-4c8c-b40a-01fdc00afa61.png)

![image](https://user-images.githubusercontent.com/69618541/192278283-5811e32d-0588-4aac-a581-fff1c3662ba2.png)

![image](https://user-images.githubusercontent.com/69618541/192278311-48cf0479-f2dd-4d73-b50a-f92da5b86308.png)

## Parameters
See comments in the codes, the parameters "n_voxels", "n_input", "n_features" should be consistent with your Data.<BR/>
Network architecture: n_input>256>128>64>n_features<BR/>
You can revise epoch number and convergence condition according to your dataset.
## Results
* ./DECBP/Reluxxcluster/dae_middletrain.npy  the features in the embedded space
* ./DECBP/Reluxxcluster/LabelFCP_train.npy the parcellation results for train dataset
* ./DECBP/Reluxxcluster/GroupLabelFCP_train.npy the group parcellation results for train dataset
* ./DECBP/Reluxxcluster/GroupLabelFCP_train.nii the group parcellation visualized results for train dataset<BR/>
These results all contain three parts, pretrain results(just autoencoders and parcellated initialization), minimum trainloss results, and final stable results(little label changed)


* ./DECBP/Reluxxcluster/ProResultsclusterxx/parcels.nii  the group parcellation visualized results for test dataset
* ./DECBP/Reluxxcluster/ProResultsclusterxx/parcelspro.nii  the group parcellation visualized probability results for test dataset


# Package dependency
* scikit-lean==0.23.1
* scipy==1.6.2
* nibabel==3.1.1
* numpy==1.20.2
* pytorch==1.6.0
* torchvision==0.7.0


# Reference
* Li Y, Liu A, Mi T, et al. Striatal Subdivisions Estimated via Deep Embedded Clustering With Application to Parkinson's Disease[J]. IEEE journal of biomedical and health informatics, 2021, 25(9): 3564-3575.
