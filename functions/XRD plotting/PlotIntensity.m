function PlotIntensity(i,Data,qData,dir,doc1,count)
% plot Debye Scherer Rings into lines

[fq,fk,~,~]=size(Data); fk=fk-1;
        %2D contour map
        xLin=linspace(0,max(max(qData(:,1:fk))),fq);
        yLin=linspace(1,fk,fk);
        [~,Dety]=meshgrid(xLin,yLin);
        
    if i==1 %reference
IntensityPlot=griddata(xLin,yLin,squeeze(trimmean(Data(:,1:fk,:),50,3))',qData(:,1:fk)',Dety,'cubic');
    elseif i~=1 %reference .. x=1;
IntensityPlot=griddata(xLin,yLin,squeeze(trimmean(trimmean(Data(:,1:fk,:,:),50,4),50,3))',...
    qData(:,1:fk)',Dety,'cubic');
    end
        imagesc(xLin,yLin,real(log10(IntensityPlot)))
%         contourf(qData(:,1:fk)',Det,yPlot);
            title(['XRDs ' num2str(doc1)]);
            set(gca,'YDir','normal')
            set(gcf,'position',[2000,400,750,550])
            ylabel('Detectors'); xlabel(['q (' char(197) '^{-1})']);
            colormap(jet(256)); caxis([0 real(log10(max(max(max(max(Data))))))]);
            c = colorbar; c.Label.String = 'log_1_0(Intensity)';%labelling
            
            dir.path = fullfile(dir.specific{count},[num2str(doc1)...
                ' Debye Scherer lines (Rings).fig']); saveas(gcf,dir.path);
            
  %% optional if you want the data along a line
%  [lineData,yplot,xplot]=LineData(xLin,yLin,IntensityPlot);  
% plot(lineData)
%  ylabel('Intensity'); xlabel(['q (' char(197) '^{-1})']);;
            
close all;