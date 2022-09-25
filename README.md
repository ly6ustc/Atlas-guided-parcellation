# Atlas-guided-parcellation(AGP)
A functionally-homogenous individual parcellation based on prior atlas 

Using AGP for individualizes cortical parcellation, see [Atlas-guided parcellation: Individualized functionally-homogenous parcellation in cerebral cortex](https://www.sciencedirect.com/science/article/pii/S0010482522007867) for more details.

# Introduction

Using Deep Embedded Connectivity-Based Parcellation for striatal subdivisions

In FCP50Subjects dir, showing parcellations with 3, 6, 7 and 8 parcel numbers. These results are obtained by DECBP framwork and FCP datasets, resampled to 2mm resolution as well.

In XW50Subjects dir, similar results are obtained by DECBP framwork and XW datasets(including 23 PD subjects and 27 HC controls).

# How to run
python DECBP.py

## Data
A numpy file with 3 dimenssion, subject × voxle × feature. The feature should be connectivity profiles, etc. For instance, the sample files in Tag DECBP:
* "eta_putamen_caudateFCPtrainhighpassleft.npy" (this is train dataset)
* "eta_putamen_caudateFCPtesthighpassleft.npy" (this file is not necessary due to the unsupervised learning, you could copy train dataset with this name)
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
