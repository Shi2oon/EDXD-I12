% function finds and elements NaNs in corners and elemen of an image
function [exx,eyy,exy,X,Y]=findNaNs3 (exx,eyy,exy,X,Y)
[fx,fy]=size(exx);

while isnan(exx(end,fy/2))
    exx(end,:)=[];	eyy(end,:)=[];	exy(end,:)=[];	X(end,:)=[];    Y(end,:)=[]; 
    [~,fy]=size(exx);
end

while isnan(exx(1,fy/2))
    exx(1,:)=[];	eyy(1,:)=[];	exy(1,:)=[];	X(1,:)=[];  	Y(1,:)=[]; 
    [~,fy]=size(exx);
end
    
while isnan(exx(fx/2,end))
    exx(:,end)=[];  eyy(:,end)=[];	exy(:,end)=[]; X(:,end)=[];  	Y(:,end)=[]; 
    [fx,~]=size(exx);
end

while isnan(exx(fx/2,1))
    exx(:,1)=[];  eyy(:,1)=[];	exy(:,end)=[]; X(:,1)=[];  	Y(:,1)=[]; 
    [fx,~]=size(exx);
end