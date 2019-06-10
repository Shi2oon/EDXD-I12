function [Q]=Qsss(Q)
Q.NumberOfPeaks = length(Q.PeakPosition);
Q.method=['gauss' num2str(Q.NumberOfPeaks)]; %gaussain fit for peaks

for peak=1:Q.NumberOfPeaks
    Q.h = Q.PeakPositionS(peak,1); 
    Q.k = Q.PeakPositionS(peak,2); 
    Q.l = Q.PeakPositionS(peak,3);
    % %from Bragg's law & the lattice spacing (d)=2*pi/q
    Q.q_guess(peak) = 2*pi*sqrt(Q.h^2+Q.k^2+Q.l^2)/Q.latticePar;
    eval(sprintf('Q.sort%d = Q.q_guess(peak);',peak));
end

[Q.theory] = Sorteddd(Q,Q.NumberOfPeaks,'Max'); %sort by 'Max' or 'min'
[Q.nn]     = findnn(Q.theory); %calculate tolearnce for peak postion
end
