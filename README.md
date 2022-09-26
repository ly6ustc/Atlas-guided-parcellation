# Atlas-guided-parcellation(AGP)
A functionally-homogenous individual parcellation based on prior atlas 

Using AGP for individualized cortical parcellation, see [Atlas-guided parcellation: Individualized functionally-homogenous parcellation in cerebral cortex](https://www.sciencedirect.com/science/article/pii/S0010482522007867) for more details.

# Introduction

Using AGP for individualized cortical parcellation

In ./Atlas dir, showes classical 7 atlases to guided the individual parcellations, you can add the new prior atlases here, by yourself.

In ./code dir, includes the AGP codes and its dependency package.

In ./sample dir, provide a examplar of HCP including the rs-fMRI images(functional connectivity) and parcellation results.

# How to run
All codes have been tested in Matlab 2017b.

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
In "Parcellation_main_T.m" or "Parcellation_main.m"

![image](https://user-images.githubusercontent.com/69618541/192279296-90281d32-ded7-42f9-bcc3-9b4da5b0c2b6.png)

Set the output directory of results.


![image](https://user-images.githubusercontent.com/69618541/192279064-53855ea1-2489-440f-a4fd-2338bbd5db6b.png)

"atlas_path" is the directory where includes the prior atlases;

Atlats = {'Shen.32k.dlabel.nii','Gordon333.32k_fs_LR.dlabel.nii'}  includes the full names of prior atlases files you want to use;

Atlatsout={'Shen200','Gordon333'}  includes the corresponding the output sub-directory names. For instance, if you use the "Shen.32k.dlabel.nii", the results will generated in '../sample/Results/AGP/sub-xxx/Shen200/'

## Results
"./sample/Results/AGP/sub-xxx/atlas-xxx/FC_REST1.dlabel.nii"

You can revised the ouput file name in "Parcellation_main_T.m" or "Parcellation_main.m", follow as:

![image](https://user-images.githubusercontent.com/69618541/192281955-32a8d586-10b9-4606-89c8-bf09ec167842.png)


# Package dependency
* cifti-matlab-master
* gifti-master
* npy-matlab-master/npy-matlab-master

These Matlab packages have been provided in ./code dir, as well as installed (add to path). 

# Reference
* Li, Yu, et al. "Atlas-guided parcellation: Individualized functionally-homogenous parcellation in cerebral cortex." Computers in Biology and Medicine (2022): 106078.
