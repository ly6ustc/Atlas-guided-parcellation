function Hom = hom(similarity,parcels)


pindex=unique(parcels);
if pindex(1)==0
    pindex=pindex(2:end);
end


N=length(parcels>0);
Hom=[];
for i = pindex'
    temp=sum(sum(similarity(parcels==i,parcels==i)))/(sum(parcels==i)*(sum(parcels==i)-1));
    Hom=[Hom;[temp*sum(parcels==i)/N,temp]];
end

end