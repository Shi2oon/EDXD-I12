% this function plot how the fitting was done in details
function PlotFitting(Data,aa,Q,qData,dir,doc1,count)

[~,fk,fj,fi] = size(Data); fk=fk-1;
jj = randi([1 fj],1); ii = randi([1 fi],1);  kk = randi([1 fk],1);
fcalib = fit(qData(:,kk),Data(:,kk,jj,ii).*aa.Factor(kk),Q.method);

%subplot(2,1,1)
plot(fcalib,qData(:,kk),Data(:,kk,jj,ii).*aa.Factor(kk))
ylabel('Intensity'); xlabel(['q (' char(197) '^{-1})']); 
set(gcf,'position',[800,100,850,650]); legend;
title (['XRD spectrum with fitting around  \{' num2str(aa.Qposition) '\} , respectively'])
% subplot(2,1,2)
% plot(xc,qData(:,kk),Data(:,kk,jj,ii),'Residuals');    title ('Fitting Residuals']
dir.path = fullfile(dir.specific{count},[num2str(doc1) ' fitting (random point).fig']);
        saveas(gcf,dir.path);

%% fWHM plot
legend ('off'); xlim([fcalib.b1*(1-Q.nn/10) fcalib.b1*(1+Q.nn/10)])
line([fcalib.b1+(fcalib.c1*2*(2*log10(2))^0.5)/2,fcalib.b1-(fcalib.c1*2*(2*log10(2))^0.5)/2]...
    ,[fcalib.a1/2,fcalib.a1/2],'Color',[0,0.5,0],'LineStyle','-.');
line([0,fcalib.b1-(fcalib.c1*2*(2*log10(2))^0.5)/2],[fcalib.a1/2,fcalib.a1/2],...
    'Color','k','LineStyle','--','HandleVisibility','off');
line([fcalib.b1,0], [fcalib.a1,fcalib.a1],'Color','k','LineStyle','--','HandleVisibility','off');
line([fcalib.b1,fcalib.b1], [fcalib.a1,0],'Color','k','LineStyle','--','HandleVisibility','off');
legend(['Peak \{' num2str(aa.Qposition(1)) '\}'],'Guassian fitted curve','FWHM')
title (['Detailed of calculations around  \{' num2str(aa.Qposition(1)) '\} Peak'])
dir.path = fullfile(dir.specific{count},[num2str(doc1) ' Detailed (random point).fig']);
        saveas(gcf,dir.path);   close all