%% plotting strain
function plotStrain(fk,Q,A,aa,dir,count,doc1,scan)
shApes={'o','s','<','d','h','p'}; 
if doc1~=scan.ref
   close all; degressD=1:fk;
        
   for peak=1:Q.NumberOfPeaks
       eval(sprintf('vo = trimmean(trimmean(A.Q%d,50,3),50,2);',peak));
       scatter(degressD,vo,shApes{peak},'filled','DisplayName',...
                ['\{' num2str(aa.Qposition(Q.NumberOfPeaks-peak+1)) '\}']);
       hold on; set(gcf,'position',[500,100,950,800])
   end
       legend('location','northwest');  
       plot(degressD,trimmean(trimmean(A.Q,50,3),50,2),'s','DisplayName','Weighted',...
            'MarkerEdgeColor','k','MarkerFaceColor','k')
       f=fit(degressD',trimmean(trimmean(A.Q,50,3),50,2),'fourier1'); 
       plot(f,'--r');hold off 
       
% Get current axes object (just plotted on) and its position
ylabel('Strain,\epsilon^{hkl}_\downarrow')
title ('Map-Averaged Microstrain and Detectors');
ax1 = gca;  axPos = ax1.Position;
% Change the position of ax1 to make room for extra axes
% format is [left bottom width height], so moving up and making shorter here...
ax1.Position = axPos + [0 0.2 0 -0.2];
% Exactly the same as for plots (above), axes LineWidth can be changed inline or after
ax1.LineWidth = 1;
% Add two more axes objects, with small multiplier for height, and offset for bottom
ax2 = axes('position', (axPos .* [1 1 1 1e-3]) + [0 0.08 0 0], 'color', 'none', 'linewidth', 1);
% You can change the limits of the new axes using XLim
ax2.XLim = [0 180];     ax1.XLim = [1 23];
% You can label the axes using XLabel.String
ax1.XLabel.String = 'Detector Element number';
ax2.XLabel.String = 'Azimuth, \downarrow (Degrees)'; 
dir.path = fullfile(dir.specific{count},[num2str(doc1) ' Strain.fig']);
saveas(gcf,dir.path);   close all
end

%% alternative
% shApes={'o','s','<','d','h','p'}; 
% if doc1~=scan.ref
%     for xi=1:2 % 1 per detctors , 2 % per azimuth
%         close all
%         if xi==1; degressD{xi}=1:fk;
%         else; degressD{xi}=0:180/(fk-1):180; degressD{xi}=round(degressD{xi}); end
%         
%         for peak=1:Q.NumberOfPeaks
%             eval(sprintf('vo=trimmean(trimmean(A.Q%d,50,3),50,2);',peak));
%             scatter(degressD{xi},vo,shApes{peak},'filled','DisplayName',...
%                 ['\{' num2str(aa.Qposition(peak)) '\}']);
%             hold on; set(gcf,'position',[500,100,950,700])
%         end
%         legend('location','northwest');  
%         plot(degressD{xi},trimmean(trimmean(A.Q,50,3),50,2),'s','DisplayName','Weighted',...
%             'MarkerEdgeColor','k','MarkerFaceColor','k')
%         f=fit(degressD{xi}',trimmean(trimmean(A.Q,50,3),50,2),'fourier1'); 
%         plot(f,'--r');hold off 
%         ylabel('Microstrain,\epsilon^{hkl}_\downarrow')
%         if xi==1; xlabel('Detector Element number');
%         else; xlabel('Azimuth, \downarrow (Degrees)'); end
%         xlim([min(degressD{xi}) max(degressD{xi})]);
%         title ('Map-averaged Microstrain and Detectors'); 
%         dir.path = fullfile(dir.specific{count},[num2str(doc1) '  '...
%             num2str(xi) ' Strain.fig']);
%         saveas(gcf,dir.path);   close all
%     end
% end
