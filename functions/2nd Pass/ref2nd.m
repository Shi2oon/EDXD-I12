function [Ref,Table] = ref2nd(dir,Points,Q,Factor,scan)
    fprintf('2nd Reference scan is being created ...\n ');
    dir.file = fullfile(dir.scan,[num2str(scan.doc2) '.nxs']);
    
    dir.Dataset = '/entry1/EDXD_elements/data';
    Data = h5read(dir.file,dir.Dataset);
    dir.qDataset = '/entry1/EDXD_elements/edxd_q';
    qData = h5read(dir.file,dir.qDataset);

[~,fk,~,~]=size(Data);    fk=fk-1;       AA.A0.A0=0; A.a0.a0=0;

for k = 1:fk % loop through detectors, one is spare
    for j=1:length(Points(:,1)) % yaxis
    % fits a Gaussian function to f (data,q)  %with 95% confidence bounds
            fcalib = fit(qData(:,k),Data(:,k,Points(j,1),Points(j,2)).*Factor(k),Q.method); 
            [A]    = findpeaks(k,j,1,fcalib,A,Q.NumberOfPeaks); %cALIBRATED
    end
end

%% calc. the peak position
% flib from big to small
Phkl  = sort(Q.PeakPosition(:),'descend');
TPP   = sort(Q.q_guess(:),'descend');
PhklS = sort(Q.PeakPositionS,'descend');
fprintf('\n\nPeak (hkl)    Theoretcial q   Optimised q     Calculated a0     tol (per)\n');

for peak=1:Q.NumberOfPeaks
    eval(sprintf('[A.A%d.b1]  = checkreplace(A.A%d.b1,scan.TH);',peak,peak));
    eval(sprintf('Ref.b%d     = trimmean(A.A%d.b1,50,2);',peak,peak));         %Reference 
    eval(sprintf('Meanb(peak) = trimmean(trimmean(A.A%d.b1,50,2),50);',peak)); %Reference
    eval(sprintf('tol(peak)   = 100*trimmean(std(A.A%d.b1,0,2),50)/Meanb(peak);',peak));
    
    Q.h  = PhklS(peak,1); 
    Q.k  = PhklS(peak,2); 
    Q.l  = PhklS(peak,3);
    % %from Bragg's law & the lattice spacing (d)=2*pi/q
    C_latticePar(peak)= 2*pi*sqrt(Q.h^2+Q.k^2+Q.l^2)/Meanb(peak);
    
fprintf('\n    %d          %.4f         %.4f          %.4f           %.4f\n',...
    Phkl(peak),TPP(peak),Meanb(peak),C_latticePar(peak),tol(peak)); 
end 
fprintf('\n');

Table = table(Phkl(:),TPP(:),Meanb(:),C_latticePar(:),tol(:),'VariableNames',...
    {'Peak_hkl', 'Theoretcial_Peak_Position', 'Optimised_Peak_Position',...
    'Calculated_lattice_Parameter', 'Tolerance_per'});
path = fullfile(dir.results,[num2str(scan.doc2) ' 2nd Scan Parameters.xlsx']);
writetable(Table, path);

