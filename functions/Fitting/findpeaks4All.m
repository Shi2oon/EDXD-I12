function [AA]=findpeaks4All(k,j,i,f,AA,NumberOfPeaks)
for peak=1:NumberOfPeaks
        eval(sprintf('c(peak)=f.b%d;',peak));
end

z=c;
for peaki=1:NumberOfPeaks
C=max(z); [peak]=ind2sub(size(c),find(c==C));
eval(sprintf('[AA.A%d.value(k,j,i),AA.A%d.b1(k,j,i),AA.A%d.FWHM(k,j,i)]=SortedValues(f,peak);'...
    ,peak,peak,peak));
z = z(z~=C);
end