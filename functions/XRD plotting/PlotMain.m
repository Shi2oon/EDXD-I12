function PlotMain(Q,fk,dir,doc1,count,aa)
 
for peak=1:Q.NumberOfPeaks
subplot(Q.NumberOfPeaks,1,peak)  
eval(sprintf('errorbar(1:fk,aa.a%d.Dmean(count,:),aa.a%d.err(count,:),"k--o",,"MarkerEdgeColor","k","MarkerFaceColor","k");'...
        ,peak,peak));
    title(['Peak \{' num2str(aa.Qposition(Q.NumberOfPeaks-peak+1)) '\} ']);
    ylabel('Intensity'); xlim([1 fk])
        set(gcf,'position',[2000,100,1000,750])
end
xlabel('Detectors'); 
dir.path = fullfile(dir.specific{count},[num2str(doc1) ...
            ' Mean Intensity.fig']);
        saveas(gcf,dir.path);    close all  
         
for peak=1:Q.NumberOfPeaks
subplot(Q.NumberOfPeaks,1,peak)  
eval(sprintf('errorbar(1:fk,aa.a%d.Dmean(count,:),aa.a%d.err(count,:),"k--o","MarkerEdgeColor","k","MarkerFaceColor","k");'...
        ,peak,peak));
    title(['Peak \{' num2str(aa.Qposition(Q.NumberOfPeaks-peak+1)) '\}']);
         ylabel('Intensity'); xlim([1 fk])
        set(gcf,'position',[2000,100,1000,750])
        hold on;
eval(sprintf('errorbar(1:fk,aa.a%d.DmeanRaw(count,:),aa.a%d.err(count,:),"b--<","MarkerEdgeColor","b","MarkerFaceColor","b");'...
        ,peak,peak));
    hold off
    legend ('Normalised','Raw');
end
xlabel('Detectors');
dir.path = fullfile(dir.specific{count},[num2str(doc1) ...
            ' Raw + Calib Mean Intensity.fig']);
        saveas(gcf,dir.path); close all 