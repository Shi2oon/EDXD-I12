function [scan_numbers,AllScans,dir,doc2,T]=mainScan(scan,aa,dir,Q,AllScans,fk)

%% main scans
count=2;        n=count+1; %the number where the count started after calib and ref
scan_numbers = scan.scan;         doc2 = scan.doc2;   
scan_numbers(scan_numbers == scan.Calib) = [];
scan_numbers(scan_numbers == scan.ref)   = [];

for doc1=scan_numbers
    tic;                fprintf('File %d is loaded ...',doc1);
    count=count+1;      [AllScans,aa,dir] = CalcScan(AllScans,aa,Q,doc1,count,dir,scan);        
    T(count)=toc;       fprintf(' and completed in %.1f minutes \n',T(count)/60);
end
T=sum(T);
%% Plot and save
fprintf('Data are being processed and FWHM analyised ... ');
dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
    num2str(scan_numbers(end)) ' Mean Intensity.mat']);
save(dir.path,'scan_numbers','AllScans','dir','doc2','aa','Q');
scan_numbers=[scan.Calib,scan_numbers];
scan_numbers=[scan.ref,scan_numbers];

for peak=1:Q.NumberOfPeaks
eval(sprintf('AllScans.err(peak,:)      = trimmean(aa.a%d.err(n:length(scan_numbers),:),50);',peak));
eval(sprintf('AllScans.Dmean(peak,:)    = trimmean(aa.a%d.Dmean(n:length(scan_numbers),:),50);',peak));
eval(sprintf('AllScans.DmeanRaw(peak,:) = trimmean(aa.a%d.DmeanRaw(n:length(scan_numbers),:),50);',peak)); 

    errorbar(1:fk,AllScans.Dmean(peak,:),AllScans.err(peak,:),'--o'); hold on
    plot(1:fk,AllScans.Dmean(peak,:),'--o'); hold off

    title(['Mean Intensity at ' num2str(aa.Qposition(peak)) ' for all scans ' ...
        num2str(scan_numbers(n)) ' to ' num2str(scan_numbers(end))]); 
    set(gcf,'position',[2000,400,750,550]);     xlabel('Detectors'); ylabel('Intensity'); 
    dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
        num2str(scan_numbers(end)) ' at ' num2str(aa.Qposition(peak)) ...
        ' Mean All Intensity.fig']);        saveas(gcf,dir.path); close all

    eval(sprintf('plot(1:fk,aa.a%d.Dmean(n:length(scan_numbers),:),"--o");',peak)); hold on; 
    title(['Mean Intensity at ' num2str(aa.Qposition(peak)) '  for scans '...
                    num2str(scan_numbers(n)) ' to ' num2str(scan_numbers(end))]); 
    legend(num2str(scan_numbers(n:end)'),'location','northeastoutside');
    set(gcf,'position',[2000,400,750,550]);     xlabel('Detectors'); ylabel('Intensity');

    plot(1:fk,AllScans.Dmean(peak,:),'--*','DisplayName','Average');
    dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
        num2str(scan_numbers(end))  ' at ' num2str(aa.Qposition(peak)) ...
        ' Mean Intensitys.fig']);               saveas(gcf,dir.path);

    plot(1:fk,AllScans.DmeanRaw(peak,:),'-->','DisplayName','Av. Raw');
    dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
        num2str(scan_numbers(end))  ' at ' num2str(aa.Qposition(peak)) ...
        ' mean Raw + Calib Intensity.fig']);    saveas(gcf,dir.path);

    eval(sprintf('plot(1:fk,aa.Ref.b%d,"--x","DisplayName","Ref.");',peak));
    hold off;   dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
                num2str(scan_numbers(end))  ' at ' num2str(aa.Qposition(peak)) ...
                ' mean Ref + Raw + Calib Intensity.fig']);  saveas(gcf,dir.path); close all 
end

%% most meangiful plots
   
for peak=1:Q.NumberOfPeaks
    subplot(Q.NumberOfPeaks,1,peak)  
    errorbar(AllScans.Dmean(peak,:),AllScans.err(peak,:),'k--o',...
        'MarkerEdgeColor','k','MarkerFaceColor','k');
title(['Peak \{' num2str(aa.Qposition(Q.NumberOfPeaks-peak+1)) '\} ']);
           ylabel('Intensity');
end
 xlabel('Detectors');
set(gcf,'position',[2000,0,1000,1000])
dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
    num2str(scan_numbers(end)) ' mean Calib Intensity.fig']);
        saveas(gcf,dir.path);     
         
close all    
for peak=1:Q.NumberOfPeaks
    subplot(Q.NumberOfPeaks,1,peak)  
    errorbar(1:fk,AllScans.Dmean(peak,:),AllScans.err(peak,:),'k--o',...
        'MarkerEdgeColor','k','MarkerFaceColor','k');
title(['Peak \{' num2str(aa.Qposition(Q.NumberOfPeaks-peak+1)) '\} ']);
            ylabel('Intensity');        hold on;
        
    errorbar(1:fk,AllScans.DmeanRaw(peak,:),AllScans.err(peak,:),'b--<',...
        'MarkerEdgeColor','b','MarkerFaceColor','b')
    hold off; legend ('Calibrated','Raw');
end
xlabel('Detectors');
set(gcf,'position',[2000,0,1000,1000])
dir.path = fullfile(dir.results,[num2str(scan_numbers(n)) ' to ' ...
    num2str(scan_numbers(end)) ' mean Raw + Calib Intensity.fig']);
saveas(gcf,dir.path); close all  

scan_numbers(scan_numbers == scan.Calib) = [];
scan_numbers(scan_numbers == scan.ref)   = [];