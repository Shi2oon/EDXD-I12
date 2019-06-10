function [Points] = find2ndPoints(NumberPo,fwhmean,Eyy)
selectedF = sort(fwhmean(:));              % sort the fwhm 
selectedE = sort(Eyy(:));  
for i=1:NumberPo % find location for small points
    [PF(i,1),PF(i,2)]=ind2sub(size(fwhmean),find(fwhmean==selectedF(i)));
    [PE(i,1),PE(i,2)]=ind2sub(size(Eyy),find(Eyy==selectedE(i)));
end

% find optimum points
counts = 0; Points=[0 0];
for i=1:NumberPo
    for ii=1:NumberPo
        if (PF(i,1)==PE(ii,1) || abs(PF(i,1)-PE(ii,1))==1 ||  abs(PF(i,1)-PE(ii,1))==2) ...
            && (PF(i,2)==PE(ii,2) || abs(PF(i,2)-PE(ii,2))==1 ||  abs(PF(i,2)-PE(ii,2))==2) 
            truthness=0;
            for iii=1:length(Points(:,1))
                if Points(iii,1)==round((PF(i,1)+PE(ii,1))/2) && ...
                        Points(iii,2)==round((PF(i,2)+PE(ii,2))/2)
                    truthness=1;%do nothing, already indexed
                end
            end
            if truthness==0
               counts=counts+1;
               Points(counts,1) = round((PF(i,1)+PE(ii,1))/2);
               Points(counts,2) = round((PF(i,2)+PE(ii,2))/2);
            end
        end
    end
end