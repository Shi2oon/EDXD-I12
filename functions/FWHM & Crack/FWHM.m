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

function FWHM (d,scan_numbers,doc2)

results_dir=d(1).folder;
results_dir= fullfile(results_dir,['FWHM Analysis ' ...
    num2str(scan_numbers(1)) '_' num2str(scan_numbers(end))]);
mkdir(results_dir);

count=0;
for doc1=scan_numbers 
count=count+1;

pyxe_f_path = fullfile(d(count).folder,d(count).name);
fwhm = h5read(pyxe_f_path,'/pyxe_analysis/fwhm');
fwhm_err = h5read(pyxe_f_path,'/pyxe_analysis/fwhm_err');
d2 = h5read(pyxe_f_path,'/pyxe_analysis/d1'); %x axis for instrument
d2=d2.*-1; x = squeeze(d2); X=x(1,:);
d1 = h5read(pyxe_f_path,'/pyxe_analysis/d2'); %y axis for instrument
d1=d1.*-1; y = squeeze(d1); Y=y(:,1);

    %% FWHM Crack at mean max. and max. max. detector
    [fk,fi,fj]=size(fwhm);
    fwhmean=squeeze(mean(fwhm));
    fwhmMean(count)=max(max(fwhmean));
    
        Dah=0;
        for k=1:fk
            for i=1:fi
                for j=1:fj
                    Dah(k,i,j)=abs(fwhmMean(count)-fwhm(k,i,j));
                end
            end
        end
    DAH=min(min(min(Dah))); [fk,fi,fj]=ind2sub(size(Dah),find(Dah==DAH));
    fwhmMean(count)=fwhm(fk,fi,fj);
    [detectormean(count), yaxismean(count),xaxismean(count)]=ind2sub(size(fwhm),find(fwhm==fwhmMean(count)));
    fwhmMean(count)=fwhm(detectormean(count), yaxismean(count),xaxismean(count));
     xaxismean(count)=X(1,xaxismean(count));
    yaxismean(count)=Y(yaxismean(count),1);
    
    fwhmMaxi(count)=max(max(max(fwhm)));
    % eror
    fwhmErr(count)=mean(mean(mean(fwhm_err)));
    
    eval(sprintf('X%d=X;Y%d=Y;fwhmean%d=fwhmean;', doc1, doc1, doc1));
    

%finding overlap window
Miniall(count)=min(min(min(fwhm))); Maxiall(count)=max(max(max(fwhm)));

    %% Decide the plotting scale and the reference point
    if doc1==doc2 % save the doc2 location
        indexdoc2=count;
    end
end

%% Continue FWHM analysis
count=1;
for doc1=scan_numbers
    distanceMaX(count)=xaxismean(count)-xaxismean(indexdoc2);  %crack increment in x direction
    distanceMaY(count)=yaxismean(count)-yaxismean(indexdoc2);   %crack increment in y direction
    TotalMAx(count)= distanceMaX(count)+distanceMaY(count); %total increment
    count=count+1;
end
    
Table = table(scan_numbers(:), fwhmMaxi(:),fwhmMean(:),detectormean(:),xaxismean(:),...
    yaxismean(:),distanceMaX(:), distanceMaY(:),TotalMAx(:),fwhmErr(:),...
    'VariableNames',{'Scan_number','FWHM_Max','FWHM','Detector',...
    'X_location','Y_location','X_increment','Y_increment','Total_increment'...
    'Error'});
pyxe_D_path = fullfile(results_dir,['Crack_location ' ...
    num2str(scan_numbers(1)) '_' num2str(scan_numbers(end)) '.xlsx']);
writetable(Table, pyxe_D_path);

%% Scalling and plotting .
Miniall=min(Miniall); Maxiall=max(Maxiall);

count=0;
for doc1=scan_numbers
    
count=count+1;
    eval(sprintf('X=X%d;Y=Y%d;fwhmean=fwhmean%d;', doc1, doc1, doc1));
    
imagesc (X,Y,fwhmean);
title(['FWHM ',num2str(doc1)]);xlabel('x(mm)');ylabel('y(mm)'); 
c = colorbar; c.Label.String = 'FWHM Value (A^{-1})';%labelling
caxis([Miniall Maxiall]); %labelling
colormap(jet(256));
pyxe_D_path = fullfile(results_dir,[num2str(doc1),' FWHM.png']);
saveas(gcf,pyxe_D_path)
end


     