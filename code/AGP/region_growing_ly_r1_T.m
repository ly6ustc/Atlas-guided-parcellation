function [labels,similarity]=region_growing_ly_r1_T(seeds, similarity_T, neibors, mask,threshold, fullnum)

%距离最短
% tic;

if ~isempty(mask)
    seeds=seeds(mask);
    similarity_T=similarity_T(mask,:);
    neibors=neibors(mask,mask);
end

similarity=nan(size(similarity_T,1));


cluster = unique(seeds);
if cluster(1)==0
    cluster = cluster(2:end);
end


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
                similarity(neibor,index)=corr(similarity_T(neibor,:)',similarity_T(index,:)');
                s=defined_similar(similarity(neibor,index));
                S_all=[S_all;{s}];
                [s_max,index]=max(s);
                temp=ind(neibor);index=single(temp(index));
                Vertex = [Vertex;[s_max,index]];
                neiborsall=[neiborsall;neibor];
            end
        end
        if ~isempty(threshold)
            threindex = Vertex(:,1)<threshold;
            clustertemp(threindex)=[];
            S_all(threindex)=[];
            Vertex(threindex,:)=[];
            neiborsall(threindex,:)=[];
        end
            cluster=clustertemp;
    else

%         tic;
        [~,indexf]=max(Vertex(:,1));
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
                    similarity(neibor,index)=corr(similarity_T(neibor,:)',similarity_T(index,:)');
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
            neiborsall(emptyindex,:)=[];
        end

        if ~isempty(threshold)
            threindex = Vertex(:,1)<threshold;
            clustertemp(threindex)=[];
            S_all(threindex)=[];
            Vertex(threindex,:)=[];
            neiborsall(threindex,:)=[];
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

if ~isempty(mask)
    labelf=zeros(size(mask));
    labelf(mask)=labels;
    labels=labelf;
end

fprintf('\nComplete!...\n');


end

% toc;

function [a,b]=defined_similar(m)
    a=mean(m,2); 
end
