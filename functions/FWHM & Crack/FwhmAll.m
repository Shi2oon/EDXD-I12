% a matlab program to measure and analyse the FWHM obtained from EDXD data
% the program takes the FWHM max. value at each measurement point and give
% the FWHM value, the location of the measurement, the crack length
% increment as measured to a reference scan and the detector where the FWHM
% where measured because choosing the max. FWHM at any detector seems 
% to be more accurate when compared with taking the max. FWHM value 
% at fixed detecor
% the program also give interpolated FWHM maps for the whole scan, then
% find the windown of overlap, and substract the reference measurmeent from
% the susquent measurement.

% created by Abdalrhaman Mohamed abd.mohamed@stx.ox.ac.uk

function FwhmAll(scan_numbers,results_dir,AllScans,doc2)
counter=0;
for doc1=scan_numbers
counter=counter+1;
eval(sprintf('fwhmean=AllScans.scan_%d.fwhmmean;',doc1));
eval(sprintf('X=AllScans.scan_%d.Xaxis; Y=AllScans.scan_%d.Yaxis;',doc1,doc1));
    %% FWHM Crack at mean max. and max. max. detector
    [fi,fj]=size(fwhmean);
    fwhmMean(counter)=max(max(fwhmean));
    
        Dah=0;
            for i=1:fi
                for j=1:fj
                    Dah(i,j)=abs(fwhmMean(counter)-fwhmean(i,j));
                end
            end
            
    DAH=min(min(Dah)); [fi,fj]=ind2sub(size(Dah),find(Dah==DAH));
    fwhmMean(counter)=fwhmean(fi,fj);
    [yaxismean(counter),xaxismean(counter)]=...
    ind2sub(size(fwhmean),find(fwhmean==fwhmMean(counter)));
    fwhmMean(counter)=fwhmean(yaxismean(counter),xaxismean(counter));
     xaxismean(counter)=X(1,xaxismean(counter));
    yaxismean(counter)=Y(yaxismean(counter),1);
    
    eval(sprintf('X%d=X;Y%d=Y;fwhmean%d=fwhmean;', doc1, doc1, doc1));
    
%finding overlap window
Miniall(counter)=min(min(fwhmean)); Maxiall(counter)=max(max(fwhmean));
end

%% Continue FWHM analysis
counter=1;
for doc1=scan_numbers
    %crack increment in x direction
    distanceMaX(counter)=xaxismean(counter)-xaxismean(1);  
    %crack increment in y direction
    distanceMaY(counter)=yaxismean(counter)-yaxismean(1); 
    %total increment
    TotalMAx(counter)= distanceMaX(counter)+distanceMaY(counter); 
    counter=counter+1;
end
    
Table = table(scan_numbers(:), fwhmMean(:),xaxismean(:),...
    yaxismean(:),distanceMaX(:), distanceMaY(:),TotalMAx(:),...
    'VariableNames',{'Scan_number','FWHM',...
    'X_location','Y_location','X_increment','Y_increment','Total_increment'});
pyxe_D_path = fullfile(results_dir,['Crack_location for ' ...
    num2str(min(scan_numbers)) '_' num2str(max(scan_numbers(end))) '.xlsx']);
writetable(Table, pyxe_D_path);

%% using Exy
[TableExy]  = CrackExy(scan_numbers,results_dir,AllScans,doc2);
[TCr]       = crackcorrected(TableExy,Table,doc2);

%% Scalling and plotting .
Miniall=min(Miniall); Maxiall=max(Maxiall);

counter=0;
for doc1=scan_numbers
    
counter=counter+1;
    eval(sprintf('X=X%d;Y=Y%d;fwhmean=fwhmean%d;', doc1, doc1, doc1));
    
imagesc (X,Y,fwhmean); hold on;
set(gca,'YDir','normal'); 
set(gcf,'position',[900,100,1000,750])
title(['FWHM ',num2str(doc1)]);
xlabel('x(mm)');ylabel('y(mm)');
c = colorbar; c.Label.String = 'FWHM Value (A^{-1})';%labelling
colormap(jet(256));         caxis([Miniall Maxiall]); %labelling
plot(TCr(counter,2),TCr(counter,3),'kp', 'MarkerSize', 15,'MarkerFaceColor','k');
legend('Est. Crack Tip'); hold off;
pyxe_D_path = fullfile(results_dir,[num2str(doc1) ' FWHM.png']);
saveas(gcf,pyxe_D_path)
end

     