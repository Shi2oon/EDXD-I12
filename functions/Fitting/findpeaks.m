function [AA]=findpeaks(k,j,i,f,AA,NumberOfPeaks)
if NumberOfPeaks==3
    [AA]=findpeaks3(k,j,i,f,AA) ;    

elseif NumberOfPeaks==2
    [AA]=findpeaks2(k,j,i,f,AA);
  
elseif NumberOfPeaks==1
    AA.A1.value(k,j,i)=f.a1; %inesnity
    AA.A1.b1(k,j,i)=f.b1; % peak positon for strain cacluation
    %Full Width Half Maxima (FWHM) from c which is related to the peak width
    AA.A1.FWHM(k,j,i) = f.c1*2*(2*log10(2))^0.5;
    
else
    % this actually should be the main function, more agile but when I wrote
    % this I was already commited in completing the stupid fucntion above :(
    [AA]=findpeaks4All(k,j,i,f,AA,NumberOfPeaks); 
end 