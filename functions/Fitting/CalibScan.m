function [AllScan,a1,dir]=CalibScan(doc,dir,count)
    close all;
%% loading
    fprintf('Normalisation scan %d is loaded ...',doc);
    dir.specific{count}= fullfile(dir.results,[num2str(doc) ' Calibration']); 
    mkdir(dir.specific{count});
    dir.file = fullfile(dir.scan,[num2str(doc) '.nxs']);
    
    dir.Dataset = '/entry1/EDXD_elements/data';
    Data = h5read(dir.file,dir.Dataset);
    dir.qDataset = '/entry1/EDXD_elements/edxd_q';
    qData = h5read(dir.file,dir.qDataset);
    
    
    %% main body
    [fq,fk,fj,fi]=size(Data); fk=fk-1;
    for k = 1:fk % loop through detectors, one is spare
        for j=1:fj
            for i=1:fi
            f = fit(qData(:,k),Data(:,k,j,i),'gauss2'); %with 95% confidence bounds
            if f.a1>f.a2
                A1.value(j,i)=f.a1; %inesnity
                A1.b1(k,j,i)=f.b1; % peak positon for strain cacluation
                %Full Width Half Maxima (FWHM) from c which is related to the peak width
                A1.FWHM(k,j,i) = f.c1*2*(2*log(2))^0.5;
                %for plotting 3D maps (q,intensity, strips at y directions
                yPlot(i,:)=Data(:,k,j,i);
            else
                A1.value(j,i)=f.a2; %inesnity
                A1.b1(k,j,i)=f.b2; % peak positon for strain cacluation
                %Full Width Half Maxima (FWHM) from c which is related to the peak width
                A1.FWHM(k,j,i) = f.c2*2*(2*log(2))^0.5;
                %for plotting 3D maps (q,intensity, strips at y directions
                yPlot(i,:)=Data(:,k,j,i);
            end
            end
            A1.yplot(j,k,:)=trimmean(yPlot,50); 
            clear yPlot
            A1.Dmean(j,k)=squeeze(trimmean(A1.value(j,:),50));
            A1.err(j,k)=squeeze(std(A1.value(j,:)));     
        end
     % inestnity with respect to detector
     a1.Dmean(count,k)=trimmean(A1.value,50); 
     a1.err(count,k)=std(A1.value);
    end
    
    %% plot 3D maps and contours for intesnity, q and detecors for points at y axis

    for j=1:fj
        xLin=linspace(0,max(max(qData(:,1:fk))),fq);
        yLin=linspace(1,fk,fk);
        [~,Det]=meshgrid(xLin,yLin);
        yPlot=griddata(xLin,yLin,Data(:,1:fk,j)',qData(:,1:fk)',Det,'cubic');
        imagesc(xLin,yLin,real(log10(yPlot)))
%         contourf(qData(:,1:fk)',Det,yPlott);
            title(['XRDs ' num2str(doc), ' along ' ...
                num2str(j) ' in the sample y axis']);
            set(gcf,'position',[2000,400,750,550])
            c = colorbar; c.Label.String = 'log_1_0(Intensity)';%labelling
            ylabel('Detectors'); xlabel('q (A^{-1})');
            colormap(jet(256));
            caxis([0 real(log10(max(max(max(max(Data))))))]);
            dir.path = fullfile(dir.specific{count},[num2str(doc) ' at '  num2str(j),' y ys XRD.png']);
            saveas(gcf,dir.path); close all;
    end
    
    %% more plotting for intensity, detectors 
    plot(1:fk,A1.Dmean,'--o'); hold on;
     title(['Mean Intensity for scans ' num2str(doc), ' along the sample y axes']);
        k=1:fj; legend(num2str(k(:)));
        set(gcf,'position',[2000,400,750,550])
        xlabel('Detectors'); ylabel('Intensity'); 
    plot(1:fk,a1.Dmean,':>','DisplayName','Average');      hold off
        dir.path = fullfile(dir.specific{count},[num2str(doc) ' ys Intensity.png']);
        saveas(gcf,dir.path);close all;
        
        %% create an excell sheet where dtector 0 is the distances in y
        % direction in the sample followed by the inetsnities at eachs y
        % strip
    
    errorbar(1:fk,a1.Dmean(count,:),a1.err(count,:),'--o'); hold on
    plot(1:fk,a1.Dmean(count,:),'--o');  
        title(['Mean Intensity for scans ',num2str(doc)]); 
        set(gcf,'position',[2000,400,750,550])
        xlabel('Detectors'); ylabel('Intensity'); 
        dir.path = fullfile(dir.specific{count},[num2str(doc) ' Mean Intensity.png']);
        saveas(gcf,dir.path);close all;
    
        %% evals
    eval(sprintf('scan_%d.fwhmmax=max(max(max(A1.FWHM)));', doc));
    eval(sprintf('scan_%d.fwhmmean=squeeze(trimmean(A1.FWHM,50));', doc));
    eval(sprintf('scan_%d.fwhmerr=squeeze(std(A1.FWHM));', doc));
    eval(sprintf('scan_%d.b1=A1.b1;',doc));
    eval(sprintf('scan_%d.a1=squeeze(a1.Dmean(count,:));',doc)); 
    eval(sprintf('scan_%d.a1err=squeeze(a1.err(count,:));',doc)); 
    dir.path = fullfile(dir.specific{count},[num2str(doc) ' Mean Intensity.mat']);
    eval(sprintf('save(dir.path,"scan_%d");',doc));
    eval(sprintf('AllScan=scan_%d; clear scan_%d A1',doc,doc));
    fprintf(' and completed\n');
end
