function [AllScans,aa]=SaveEvales(Q,A,aa,dir,count,doc1,x,y,fy,scan,AllScans)
for peak=1:Q.NumberOfPeaks
    eval(sprintf('scan_%d.fwhmmean%d=squeeze(trimmean(A.A%d.FWHM,50));',...
        doc1,peak,peak));
    eval(sprintf('scan_%d.fwhmerr%d=squeeze(std(A.A%d.FWHM))./2;',doc1,peak,peak));
    eval(sprintf('scan_%d.a%d=squeeze(aa.a%d.Dmean(count,:));',doc1,peak,peak));
    eval(sprintf('scan_%d.a%derr=squeeze(aa.a%d.err(count,:));',doc1,peak,peak));
    
    if doc1==scan.ref
        eval(sprintf('aa.Ref.b%d=trimmean(A.A%d.b1,50,2);',peak,peak));%Reference
        eval(sprintf('scan_%d.Q%d=trimmean(A.A%d.b1,50,2);',doc1,peak,peak));
        alldata=0;
    else
        eval(sprintf('scan_%d.Q%d=A.Q%d;',doc1,peak,peak));
        if peak==Q.NumberOfPeaks
%% straind calculation
        [A.Strain] = StrainTensors2(A.Q, scan.TH); %caclulate strain
% dir.path = fullfile(dir.specific{count},[num2str(doc1) ...
%  '  Mohrs Circle (Random point).png']); saveas(gcf,dir.path);   close all
        A.Strain.Y=dir.y;           A.Strain.X=dir.x;
        alldata=[A.Strain.X(:) A.Strain.Y(:) A.Strain.exx(:)...
                    A.Strain.eyy(:) A.Strain.exy(:)];
                
        plot_strains(A.Strain,doc1,dir.specific{count})
            eval(sprintf('scan_%d.Q        = A.Q;',doc1));
            eval(sprintf('scan_%d.Strain   = A.Strain;',doc1));
            eval(sprintf('scan_%d.Yaxis    = y; scan_%d.Xaxis = x;',doc1,doc1));
            eval(sprintf('scan_%d.fwhmmean = squeeze(trimmean(aa.fwhmmean,50));',doc1));
        
        eval(sprintf('imagesc(x,y,scan_%d.fwhmmean);', doc1));
            set(gca,'YDir','normal') 
            set(gcf,'position',[2000,400,750,550])
            title(['FWHM with y-axis location for the plotted intesity ',...
            num2str(doc1)]);
            xlabel('x(mm)');ylabel('y(mm)'); 
            c = colorbar; c.Label.String = 'FWHM vlaue (A^{-1})';%labelling
            colormap(jet(256));
            dir.path = fullfile(dir.specific{count},[num2str(doc1)...
            ' All FWHM.png']);  saveas(gcf,dir.path);   close all
        end
     %% higlight the location of the y-axis
        eval(sprintf('imagesc(x,y,scan_%d.fwhmmean%d);', doc1,peak));
        set(gca,'YDir','normal')
        for i=1:fy:length(y)
            line([x(1);x(end)],[y(i);y(i)],'Color','white','linestyle','- -');
        end
        legend(num2str(y(1:fy:end)),'Location','NorthEast');
        set(gcf,'position',[2000,400,750,550])
        title([num2str(aa.Qposition(peak))...
      ' Q FWHM with y-axis location for the plotted intesity ',num2str(doc1)]);
        xlabel('x(mm)');ylabel('y(mm)'); 
        c = colorbar; c.Label.String = 'FWHM vlaue (A^{-1})';%labelling
        colormap(jet(256));
        dir.path = fullfile(dir.specific{count},[num2str(doc1) ' '...
         num2str(aa.Qposition(peak)) ' FWHM.png']);
        saveas(gcf,dir.path);   close all
    end
end

%% saving everything
dir.path = fullfile(dir.specific{count},[num2str(doc1) ' Mean Intensity.mat']);
eval(sprintf('save(dir.path,"scan_%d","alldata");',doc1));
    eval(sprintf('AllScans.scan_%d=scan_%d;',doc1,doc1));
    
if doc1==scan.doc2
    eval(sprintf('AllScans.RefScan = scan_%d;',doc1));
end