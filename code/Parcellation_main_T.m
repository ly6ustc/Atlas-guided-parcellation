
%%%%%%

addpath(genpath('./'));


% import medial wall surface file

medialwall_l=gifti('AGP/medial_wall.L.32k_fs_LR.func.gii');
medialwall_l=medialwall_l.cdata;
medialwall_r=gifti('AGP/medial_wall.R.32k_fs_LR.func.gii');
medialwall_r=medialwall_r.cdata;

% import surface structrual file

left=gifti('AGP/Conte69.L.midthickness.32k_fs_LR.surf.gii');
right=gifti('AGP/Conte69.R.midthickness.32k_fs_LR.surf.gii');



    

path = '../sample/Timecourse/';
outputpath= '../sample/Results/';



list=dir(path);
list={list([list(:).isdir]).name};
list=list(3:end);

neibors = logical(importdata('AGP/neibors.mat'));

atlas_path='../Atlas/';

Atlats = {'Shen.32k.dlabel.nii','Gordon333.32k_fs_LR.dlabel.nii'};

Atlatsout={'Shen200','Gordon333'};





    

for i =1:length(list)
    
    similarity=ciftiopen([path,list{i},'/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii']);
    
    similarity_l=single(cifti_struct_dense_extract_surface_data(similarity, 'CORTEX_LEFT'));
    
    similarity_r=single(cifti_struct_dense_extract_surface_data(similarity, 'CORTEX_RIGHT'));
    

    clear similarity;
    
    
    
        
    disp(list{i}); 
    
    for k=1:length(Atlats)        
        
        key=Atlatsout{k};
        
        load('AGP/atlas.mat');
    
        [~,~,ext]=fileparts(Atlats{k});
        
        if strcmp(ext,'.mat')
            load([atlas_path,Atlats{k}]);
            cif=ciftiopen([atlas_path,'Schaefer2018_400Parcels_17Networks_order.dlabel.nii']);
        else
            cif=ciftiopen([atlas_path,Atlats{k}]);
            atlas.l_parcel=cifti_struct_dense_extract_surface_data(cif,'CORTEX_LEFT');
            atlas.r_parcel=cifti_struct_dense_extract_surface_data(cif,'CORTEX_RIGHT');
        end
        
        surfinfo_l = cifti_diminfo_dense_get_surface_info(cif.diminfo{1}, 'CORTEX_LEFT');
        surfinfo_r = cifti_diminfo_dense_get_surface_info(cif.diminfo{1}, 'CORTEX_RIGHT');
        
        leftnum=sum(atlas.l_parcel>0);
        rightnum=sum(atlas.r_parcel>0);       
        
        ind_parcel_l=CenterBackFM_ly(atlas.l_parcel,atlas.l_neib,atlas.l_neib_max,left);
%         ind_parcel_l=find_center_T(similarity_l,atlas.l_parcel);
        ind_parcel_r=CenterBackFM_ly(atlas.r_parcel,atlas.r_neib,atlas.r_neib_max,right);
%         ind_parcel_r=find_center_T(similarity_r,atlas.r_parcel);        

        
        
        
        %for AGP


        mkdir([outputpath,'AGP/',list{i},'/',key]);

        tic;

        labels_l=region_growing_ly_r1_T(ind_parcel_l, similarity_l,neibors,medialwall_l==0,[],leftnum);
        labels_r=region_growing_ly_r1_T(ind_parcel_r, similarity_r, neibors,medialwall_r==0,[],rightnum);
        
        toc;

        
        cif.cdata(surfinfo_l.ciftilist, :) = single(labels_l(surfinfo_l.vertlist1, :));
        cif.cdata(surfinfo_r.ciftilist, :) = single(labels_r(surfinfo_r.vertlist1, :));
        

        ciftisave(cif,[outputpath,'AGP/',list{i},'/',key,'/FC_REST1_T.dlabel.nii']);
  
    end
end


rmpath(genpath('./'));









