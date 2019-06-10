function [A,AA,aa,QF,i]=CalcFitting(Data,qData,aa,Q,doc1,scan,count)
[~,fk,fj,fi]=size(Data); fk=fk-1;
    AA.A0.A0=0; A.a0.a0=0;
QF=zeros(fk,fj,fi); % factor

for k = 1:fk % loop through detectors, one is spare
    for j=1:fj % yaxis
        for i=1:fi % x axis
% fits a Gaussian function to f (data,q)  %with 95% confidence bounds
            fcalib = fit(qData(:,k),Data(:,k,j,i).*aa.Factor(k),Q.method); 
            [A]    = findpeaks(k,j,i,fcalib,A,Q.NumberOfPeaks); %cALIBRATED
            
            f      = fit(qData(:,k),Data(:,k,j,i),Q.method); % Raw
            [AA]   = findpeaks(k,j,i,f,AA,Q.NumberOfPeaks);
            
            %% strain
         for peak=1:Q.NumberOfPeaks
            if doc1~=scan.ref    
                eval(sprintf('QF(k,j,i)     = A.A%d.value(k,j,i)+QF(k,j,i);',peak));
                eval(sprintf('A.Q%d(k,j,i)  = (aa.Ref.b%d(k)/A.A%d.b1(k,j,i))-1;',...
                        peak,peak,peak));
            %%FWHM
            end
         end 
        end
            for peak=1:Q.NumberOfPeaks
eval(sprintf('AA.A%d.Dmean(j,k) = squeeze(squeeze(trimmean(A.A%d.value(k,j,:),50)));',...
    peak,peak));
eval(sprintf('AA.A%d.err(j,k)   = squeeze(squeeze(std(A.A%d.value(k,j,:))))./2;',...
    peak,peak));
            end
    end
     % inestnity with respect to detector
    for peak=1:Q.NumberOfPeaks
    eval(sprintf('aa.a%d.DmeanRaw(count,k) = trimmean(trimmean(AA.A%d.value(k,:,:),50,3),50,2);'...
        ,peak,peak));
    eval(sprintf('aa.a%d.errRaw(count,k)   = trimmean(std(squeeze(AA.A%d.value(k,:,:))),50)./2 ;',...
        peak,peak));
    eval(sprintf('aa.a%d.Dmean(count,k)    = trimmean(trimmean(squeeze(A.A%d.value(k,:,:)),50),50);'...
        ,peak,peak));
    eval(sprintf('aa.a%d.err(count,k)      = trimmean(std(squeeze(AA.A%d.value(k,:,:))),50)./2 ;',...
        peak,peak));
    end 
end