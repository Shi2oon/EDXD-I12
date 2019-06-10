function [A,aa]=weightStrainFWHM(fi,fj,fk,Q,A,aa,QF)
%% Weight function for FWHM and Strain

    for i=1:fi % x axis
        for j=1:fj % yaxis    
            for k = 1:fk % loop through detectors, one is spare
                for peak=1:Q.NumberOfPeaks
eval(sprintf('A.Q(k,j,i)=A.Q%d(k,j,i)*(A.A%d.value(k,j,i)/QF(k,j,i))+A.Q(k,j,i);',peak,peak));
eval(sprintf('aa.fwhmmean(k,j,i)=A.A%d.FWHM(k,j,i)*(A.A%d.value(k,j,i)/QF(k,j,i))+aa.fwhmmean(k,j,i);'...
    ,peak,peak));
                end
            end 
        end
    end
