function [fy]=PlotAlongY(Q,AA,aa,count,doc1,dir,fk)
%% more plotting for intensity, detectors  
% + create an excell sheet where dtector 0 is the distances in y
   % direction in the sample followed by the inetsnities at eachs y
     % strip
     y=dir.y;
for peak=1:Q.NumberOfPeaks
    fy=length(y)/5; fy=round(fy+.25);
    eval(sprintf('plot(1:fk,AA.A%d.Dmean(1:fy:end,:),"--o");',peak)); hold on;
     title(['Mean Intensity at \{' num2str(aa.Qposition(peak)) '\} for scans '...
         num2str(doc1), ' along the sample y axes']);
        legend(num2str(y(1:fy:end)'));
        set(gcf,'position',[2000,400,750,550])
        xlabel('Detectors'); ylabel('Intensity'); 
eval(sprintf('plot(1:fk,aa.a%d.Dmean(count,:),":>","DisplayName","Average");'...
    ,peak)); hold off
        dir.path = fullfile(dir.specific{count},[num2str(doc1) ' ' ...
            num2str(aa.Qposition(peak)) ' ys Intensity.fig']);
        saveas(gcf,dir.path); close all;
        
eval(sprintf('tablex = AA.A%d.Dmean(1:fy:end,:);',peak));
tablex=[y(1:fy:end,1)';tablex'];
        name=[num2str(doc1) ' ' num2str(aa.Qposition(peak)) ];
Table = table((0:fk)', tablex,'VariableNames',{'Detector_Number','Inesnity'});
        writetable(Table, dir.Excel, 'sheet',name);
    
eval(sprintf('errorbar(1:fk,aa.a%d.Dmean(count,:),aa.a%d.err(count,:),"k--o","MarkerEdgeColor","k","MarkerFaceColor","k");'...
        ,peak,peak)); hold on
        title(['Mean Intensity at \{' num2str(aa.Qposition(peak)) '\}'...
            '  for scans ',num2str(doc1)]); 
        set(gcf,'position',[2000,400,750,550])
        xlabel('Detectors'); ylabel('Intensity'); 
        dir.path = fullfile(dir.specific{count},[num2str(doc1) ' ' ...
            num2str(aa.Qposition(peak)) ' Mean Intensity.fig']);
        saveas(gcf,dir.path);
        
    eval(sprintf('plot(1:fk,aa.a%d.DmeanRaw(count,:),"b-->",,"MarkerEdgeColor","b","MarkerFaceColor","b");',peak)); hold off;
    legend ('Normalised','Raw');
    dir.path = fullfile(dir.specific{count},[num2str(doc1) ' ' ...
        num2str(aa.Qposition(peak)) ' Raw + calib Intensity.fig']); 
    saveas(gcf,dir.path); close all;
end