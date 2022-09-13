function seed=find_center(matrix,parcels)
    seed=zeros(size(parcels));
    index=1:length(parcels);
    a=unique(parcels);
    if a(1)==0
        a=a(2:end);
    end
    for i =a'
        t=matrix(parcels==i,parcels==i);
        t=sum(t);
        [~,ind]=max(t);
        vertex=index(parcels==i);
        vertex=vertex(ind);
        seed(vertex)=i;
    end
end