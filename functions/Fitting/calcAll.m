% this is main function for fitting, FWHM, strain, plotting and save data
% for scans
function [AllScans,aa]=calcAll(AllScans,Data,qData,aa,Q,y,x,doc1,count,dir,scan)

%% fitting and fitting parameters
[~,fk,fj,fi]   = size(Data); fk=fk-1;
[A,AA,aa,QF,i] = CalcFitting(Data,qData,aa,Q,doc1,scan,count);
    
%% check inconsistency
A.Q=zeros(fk,fj,fi);                aa.fwhmmean=zeros(fk,fj,fi);
for peak = 1:Q.NumberOfPeaks
    eval(sprintf('[A.A%d.b1]  = checkreplace(A.A%d.b1,scan.TH);',peak,peak));
    if doc1 ~= scan.ref
        eval(sprintf('[A.Q%d] = checkreplace(A.Q%d,scan.TH);',peak,peak));
    end
end
[A.Q] = checkreplace(A.Q,scan.TH);

%% Weight function for FWHM and Strain
if doc1   ~= scan.ref
    [A,aa] = weightStrainFWHM(fi,fj,fk,Q,A,aa,QF);
end

%% find the corresponding peak
[aa] = FindPeak(aa,Q,AA);

%% plot how the fitting is done
PlotFitting(Data,aa,Q,qData,dir,doc1,count);

%% plot contours for intesnity, q and detecors for points at y axis
PlotIntensity(i,Data,qData,dir,doc1,count);
    
%% Plot and save data along y axes
[fy] = PlotAlongY(Q,AA,aa,count,doc1,dir,fk);

%% most meaningful plots
PlotMain(Q,fk,dir,doc1,count,aa);

%% Save and plot FWHM + Strain calculaitons
[AllScans,aa] = SaveEvales(Q,A,aa,dir,count,doc1,x,y,fy,scan,AllScans);

%% plotting strain
plotStrain(fk,Q,A,aa,dir,count,doc1,scan);