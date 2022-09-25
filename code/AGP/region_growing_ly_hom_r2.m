function labels=region_growing_ly_hom_r2.m(seeds, similarity, neibors,mask, threshold, fullnum)

%距离最短

if ~isempty(mask)
    seeds=seeds(mask);
    similarity=similarity(mask,mask);
    neibors=neibors(mask,mask);
end

if isempty(threshold)
    threshold=-1;
end

cluster = unique(seeds);
if cluster(1)==0
    cluster = cluster(2:end);
end
% tic;

% threshold=0;
labels=seeds;
totalnum=length(labels);
emptynum=totalnum-fullnum;
num = sum(labels==0);
dim=floor(log10(num))+1;
ind=1:totalnum;

%Initalize the similarity clusters center and their neibors
Vertex = [];
S_all = [];
neiborsall=logical([]);



fprintf('Start...\n');

fprintf(['Remain ',num2str(num,['%0',num2str(dim)','d']), ' vertices']);


while num>emptynum && ~isempty(cluster)

    string = ['Remain ',num2str(num,['%0',num2str(dim)','d']), ' vertices'];
    fprintf([repmat('\b',1,length(string)) '%s'],string);
    
    if isempty(Vertex)
        clustertemp = cluster;
        for i =1:length(cluster)
            index= labels==cluster(i);
            neibor = sum(neibors(index,:),1);
            neibor = logical(logical(neibor)-labels'>0);
            if sum(neibor)==0
                clustertemp(clustertemp==cluster(i))=[];
            else
                s=defined_similar(similarity(neibor,index));
                S_all=[S_all;{s}];
                [s_max,index]=max(s);
                temp=ind(neibor);index=single(temp(index));
                Vertex = [Vertex;[s_max,index]];
                neiborsall=[neiborsall;neibor];
            end
        end
%         threindex = Vertex(:,1)<threshold;
%         clustertemp(threindex)=[];
%         S_all(threindex)=[];
%         Vertex(threindex,:)=[];
        cluster=clustertemp;
        Hom=zeros(length(cluster),1);
        Num_vertex=ones(length(cluster),1);

    else

%         tic;
%         [t,indexf]=max(Vertex(:,1));
%         temp=(Vertex(:,1)-Hom)./(Num_vertex+1);
        temp=2*Vertex(:,1)-Hom;
%         temp=(2*Vertex(:,1)-Hom)*(totalnum-num)-Hom.*Num_vertex;
        [~,indexf]=max(temp);
        
        if Vertex(indexf,1)< threshold && Hom(indexf)<threshold
            clustertemp(indexf)=[];
            S_all(indexf)=[];
            Vertex(indexf,:)=[];
            cluster=clustertemp;
            Hom(indexf)=[];
            Num_vertex(indexf)=[];
            neiborsall(indexf,:)=[];
        else
            Hom(indexf)= (Hom(indexf)*(Num_vertex(indexf)-1)*Num_vertex(indexf)+2*Vertex(indexf,1)*Num_vertex(indexf))/((Num_vertex(indexf)+1)*Num_vertex(indexf));
            Num_vertex(indexf)=Num_vertex(indexf)+1; 
            
            index_cache=Vertex(indexf,2);
            labels(index_cache) = clustertemp(indexf);
            %         toc;
        
    %         tic;
            %%updata the S
            g=neibors(index_cache,:);
            g=unique(labels(g));
            g=intersect(g,cluster);
            for j=unique(g)'
                g(g==j)=find(cluster==j);
            end 
    %         toc;

    %         tic;

            emptyindex=false(length(cluster),1);

            for i = g'
                if i==indexf

                    index= labels==cluster(i);
                    neiborsall(i,neibors(index_cache,:))=1;
                    neiborsall(i,labels>0) = 0;
                    neibor=neiborsall(i,:);

                    if sum(neibor)==0
                        emptyindex(i)=1;
                    else
                        s=defined_similar(similarity(neibor,index));
                        S_all{i}=s;
                        [s_max,index]=max(s);
                        temp=ind(neibor);index=single(temp(index));
                        Vertex(i,:) = [s_max,index];
                    end 
                else

                    index= labels==cluster(i);
                    neiborsall(i,index_cache)=0;
                    neibor= neiborsall(i,:);
                    
                    if sum(neibor)==0
                        emptyindex(i)=1;
                    else
                        neibor(index_cache)=1;
                        temp=S_all{i};
                        temp(find(neibor)==index_cache)=[];
                        S_all{i}=temp;
                        [s_max,index]=max(temp);
                        neibor(index_cache)=0;
                        temp=ind(neibor);index=single(temp(index));
                        Vertex(i,:) = [s_max,index];
                    end
                end
            end
            if sum(emptyindex)
                S_all(emptyindex)=[];
                Vertex(emptyindex,:)=[];
                clustertemp(emptyindex)=[];
                Hom(emptyindex)=[];
                Num_vertex(emptyindex)=[]; 
                neiborsall(emptyindex,:)=[];
            end
            cluster=clustertemp;
    %         toc;

            %updata end
            if isempty(Vertex)
                break;
            end

            num = sum(labels==0);                        
        end
    end
    
end
if ~isempty(mask)
    labelf=zeros(size(mask));
    labelf(mask)=labels;
    labels=labelf; 
end
fprintf('\nComplete!...\n');

% toc;
% labelf=zeros(length(medialwall),1);
% labelf(~logical(medialwall))=labels;
% 
% cif=ciftiopen('/home/z/DataStorage/lyPython/PDAtlas/gradient2/Gradient_Individual/PPMI/Parcellation/Parcels_Merge/EtaPD_Z_gradient_mean0.1_mergeKNN.dlabel.nii');
% cif.cdata(1:length(labelf))=labelf;
% ciftisave(cif,'test_com.dlabel.nii');
% 
% 
% save(gifti(labelf),'test_com.func.gii');

end

function [a]=defined_similar(m)
    a=mean(m,2); 
end
