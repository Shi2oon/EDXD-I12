% Calibration
function [aa,ClaibScan,AllScans]=CalcCalb(ClaibScan,dir,fk,ClaibScansC,Q)
if ClaibScan(1)~= 'NO'
if length(ClaibScan)==1
    docCalib    = ClaibScan;
    dir.results = dir.result;
else
    docCalib = 66666;%arbituary number to save mean of calibration scans
    dirresults = [dir.results '\' num2str(ClaibScan(1)) ' to '...
        num2str(ClaibScan(end)) ' Calibration']; mkdir(dirresults);
end    

L=0; 
for docCalib2=ClaibScan
    L=L+1;
    [AllScan,a1,dir]  = CalibScan(docCalib2,dir,1);
    Calib.fwhmmax(L)  = AllScan.fwhmmax;
    Calib.fwhmmean(L) = AllScan.fwhmmean;
    Calib.fwhmerr(L)  = AllScan.fwhmerr;
    Calib.B1(:,L)     = AllScan.b1;
    Calib.Aa1(L,:)    = AllScan.a1; % the high inetsinty in each scan
    Calib.a1err(L,:)  = AllScan.a1err;
end

 close all; 
plot (1:fk,Calib.Aa1,'--o'); hold on;
legend (num2str(ClaibScan(:)));

if length(ClaibScan)~=1
    plot (1:fk,mean(Calib.Aa1),':>','DisplayName','Average'); 
    AllScan.fwhmmax  = trimmean(Calib.fwhmmax(ClaibScansC(1):ClaibScansC(2)),50);
    AllScan.fwhmmean = trimmean(Calib.fwhmmean(ClaibScansC(1):ClaibScansC(2)),50);
    AllScan.fwhmerr  = trimmean(Calib.fwhmerr(ClaibScansC(1):ClaibScansC(2)),50);
    
    Calib.B1C        = Calib.B1(:,ClaibScansC(1):ClaibScansC(2));
    AllScan.b1       = mean(Calib.B1C,2);
    
    Calib.Aa1C       = Calib.Aa1(ClaibScansC(1):ClaibScansC(2),:); 
    AllScan.a1       = trimmean(Calib.Aa1C,50);
    AllScan.a1err    = std(Calib.Aa1C)./2;
    Calib.Dmean      = trimmean(Calib.Aa1C,50);
else
    Calib.Aa1C       = Calib.Aa1;
    Calib.Dmean      = AllScan.a1;
end

hold off;
title(['Raw Highest Intensity for all Ceria scans ' num2str(ClaibScan(1))...
    ' to ' num2str(ClaibScan(end))]); 
set(gcf,'position',[2000,400,1000,550])
xlabel('Detectors');        ylabel('Intensity'); 
dir.path = fullfile(dir.results,[num2str(ClaibScan(1)) ' to ' ...
    num2str(ClaibScan(end)) ' Raw Intensities.png']);
saveas(gcf,dir.path);  close all; 

%% define Calibration
eval(sprintf('AllScans.scan_%d.fwhmmax  = AllScan.fwhmmax;',ClaibScan));
eval(sprintf('AllScans.scan_%d.fwhmmean = AllScan.fwhmmean;',ClaibScan));
eval(sprintf('AllScans.scan_%d.fwhmerr  = AllScan.fwhmerr;',ClaibScan));
eval(sprintf('AllScans.scan_%d.b1       = AllScan.b1;',docCalib));
eval(sprintf('AllScans.scan_%d.a1       = AllScan.a1;',docCalib));
eval(sprintf('AllScans.scan_%d.a1err    = AllScan.a1err;',docCalib));
        
        % calculateing the calibration factor
counter=0;
for ii=ClaibScansC(1):1:ClaibScansC(2)
     counter=counter+1;
      for iii=1:fk
%      Calib.Factors(counter,iii)   = trimmean(Calib.Aa1(ii,:),50)/Calib.Aa1(ii,iii);
         Calib.Factors(counter,iii) = Calib.Aa1(ii,round(fk/2))/Calib.Aa1(ii,iii);
      end
end
if counter~=1
   Calib.Factor  = trimmean(Calib.Factors,50);
else
    Calib.Factor = Calib.Factors;
end
aa.Factor        = Calib.Factor;
        
close all;       
plot(1:fk,Calib.Factors,'--o'); hold on;
title(['Clibration factors for scan ' num2str(ClaibScan(ClaibScansC(1))) ' to '...
     num2str(ClaibScan(ClaibScansC(2)))]); 
legend (num2str(ClaibScan(ClaibScansC(1):ClaibScansC(2))'),...
    'location','northeast');
set(gcf,'position',[2000,400,1000,550])
xlabel('Detectors'); ylabel('Intensity'); 
plot (1:fk,Calib.Factor,':>','DisplayName','Average');  
        dir.path = fullfile(dir.results,[num2str(ClaibScan(1)) ' to ' ...
                    num2str(ClaibScan(end)) ' CF.png']);
        saveas(gcf,dir.path);
        
    line([round(fk/2) round(fk/2)],[0 1],...
            'Color','k','LineStyle','--','HandleVisibility','off')
    line([0 round(fk/2)],[1 1],...
            'Color','k','LineStyle','--','DisplayName',[num2str(round(fk/2)) ':1'])
        hold off;
        dir.path = fullfile(dir.results,[num2str(ClaibScan(1)) ' to ' ...
                    num2str(ClaibScan(end)) ' CF lined.png']);
        saveas(gcf,dir.path)

        
plot(1:fk,Calib.Aa1C.*Calib.Factor,'--o'); hold on;
title(['Clibrated scan ' num2str(ClaibScan(ClaibScansC(1))) ' to ' ...
    num2str(ClaibScan(ClaibScansC(2)))]); 
legend (num2str(ClaibScan(ClaibScansC(1):ClaibScansC(2))'));
xlabel('Detectors'); ylabel('Intensity'); 
if counter~=1
plot (1:fk,trimmean(Calib.Aa1C,50).*Calib.Factor,':>','DisplayName','Average');
end
hold off;   
dir.path = fullfile(dir.results,[num2str(ClaibScan(1)) ' to ' ...
           num2str(ClaibScan(end)) ' Calibrated Ceria.png']);
        saveas(gcf,dir.path);
        
   dir.path = fullfile(dir.results,[num2str(ClaibScan(1)) ' to ' ...
        num2str(ClaibScan(end)) ' Intensity.mat']);
    save(dir.path,'Calib');

    
plot(1:fk,Calib.Dmean,'--X','DisplayName','Av. Raw'); hold on;
legend ('location','northeast');
plot(1:fk,Calib.Dmean.*Calib.Factor,'--o','DisplayName','Av. Normalised');hold off;   
title(['Raw and Normalised Average Inteinsities from ' num2str(ClaibScan...
    (ClaibScansC(1))) ' to ' num2str(ClaibScan(ClaibScansC(2)))]); 
set(gcf,'position',[2000,400,1000,550])
xlabel('Detectors'); ylabel('Intensity'); 
        dir.path = fullfile(dir.results,[num2str(ClaibScan(1)) ' to ' ...
                    num2str(ClaibScan(end)) ' Average CF & RAW.png']);
        saveas(gcf,dir.path);

    close all;
    clear docCalib2
    ClaibScan=docCalib;
else
    Calib.Dmean = ones(1,fk);
    aa.Factor   = ones(1,fk);
end
    
for peak=1:Q.NumberOfPeaks
eval(sprintf('aa.a%d.DmeanRaw(1,:) = Calib.Dmean;',peak))
eval(sprintf('aa.a%d.Dmean(1,:)    = Calib.Dmean;',peak))
end