function [ ind_parcel ] = CenterBackFM_ly( atlas_parcel, neighbor, max_neighbor, vertice_loc)

% this script is revised by https://github.com/sherryaa4/functional-parcellation/CenterBackFM.m

parcels=unique(atlas_parcel);%revised by ly
if parcels(1)==0
    parcels=parcels(2:end);%revised by ly
end

N_parcel=length(parcels);  %revised by ly
N_ver=length(atlas_parcel);
ver_label=zeros(N_ver,1);
center_ver=zeros(N_parcel,1);




% compute geo distance of every vertex with its neighbors
location_ver=vertice_loc.vertices;
nei_dist=zeros(length(atlas_parcel),10);
for i=1:length(atlas_parcel)
    for j=1:max_neighbor(i)
        nei_dist(i,j)=sqrt((location_ver(i,1)-location_ver(neighbor(i,j),1))*(location_ver(i,1)-location_ver(neighbor(i,j),1))+(location_ver(i,2)-location_ver(neighbor(i,j),2))*(location_ver(i,2)-location_ver(neighbor(i,j),2))+(location_ver(i,3)-location_ver(neighbor(i,j),3))*(location_ver(i,3)-location_ver(neighbor(i,j),3)));
    end
end

%find edge vertex
for num=1:N_parcel
    ind=find(atlas_parcel==parcels(num));%revised by ly
    for j=1:length(ind)
        cur=neighbor(ind(j),:);
        for k=1:max_neighbor(ind(j))
            if atlas_parcel(cur(k))~=parcels(num)%revised by ly
                ver_label(ind(j))=1;
                break;
            end
        end
    end
end

edge_vers=find(ver_label==1);

%prepare backtrace fastmarching
v_time=zeros(N_ver,1)+1e10;
v_time(edge_vers)=0;

%      tmp_sim=nei_dist;
%     nzero_ind=find(nei_dist~=0);
%     tmp_sim(nzero_ind)=1;
%     nan_ind=find(isnan(nei_dist));
%     tmp_sim(nan_ind)=nan;
dist=nei_dist;
%     dist=1-nei_sim;
%     dist=dist.*dist; %this should be modified to fit different situation

stat=zeros(N_ver,1); %Far=0, Open=1, Dead=2, useless=-2;
stat(edge_vers)=1;
stat(find(atlas_parcel==0))=-2;

%start fast marching

while sum(stat==0)>0
    Open=find(stat==1);
    [M,Ind]=min(v_time(Open));
    cur=Open(Ind(1));
    stat(cur)=2;
    for i=1:max_neighbor(cur)
        if stat(neighbor(cur,i))==0
            stat(neighbor(cur,i))=1;
        end
    end
    for i=1:max_neighbor(cur)
        nei=neighbor(cur,i);
        if stat(nei)==1
            for j=1:max_neighbor(nei)
                if stat(neighbor(nei,j))>0
                    c_time=v_time(neighbor(nei,j))+dist(nei,j);
                    if c_time<v_time(nei)
                        %                             ind_parcel(nei)=ind_parcel(neighbor(nei,j));
                        v_time(nei)=c_time;
                    end
                end
            end
            
        end
    end
    
end
temp=find(v_time==1e10);
v_time(temp)=-1;
for i=1:N_parcel
    indd=find(atlas_parcel==parcels(i));%revised by ly
    temp2=v_time(indd);
    tmp=indd(find(temp2==max(temp2)));
    
    % if all vertex was on the edge, choose the vertex having maximal correlation with others
    if length(tmp)>1
        geo_center=mean(location_ver(indd,:));
        tmp_dist=zeros(length(indd),1);
        for j=1:length(indd)
            tmp_dist(j)=sqrt((location_ver(indd(j),1)-geo_center(1))*(location_ver(indd(j),1)-geo_center(1))+(location_ver(indd(j),2)-geo_center(2))*(location_ver(indd(j),2)-geo_center(2))+(location_ver(indd(j),3)-geo_center(3))*(location_ver(indd(j),3)-geo_center(3)));
        end
        center_ver(i)=indd(find(tmp_dist==min(tmp_dist)));

    else
        center_ver(i)=tmp;
    end
    
 
end

ind_parcel=zeros(N_ver,1);
for i=1:N_parcel
    ind_parcel(center_ver(i))=parcels(i);%revised by ly
end






end

