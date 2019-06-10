function [AA]=findpeaks3(k,j,i,f,AA)    
    if f.b1>f.b2 && f.b1>f.b3
        AA.A1.value(k,j,i)=f.a1; %inesnity
        AA.A1.b1(k,j,i)=f.b1; % peak positon for strain cacluation
        %Full Width Half Maxima (FWHM) from c which is related to the peak width
        AA.A1.FWHM(k,j,i) = f.c1*2*(2*log10(2))^0.5;
        if f.b2>f.b3
            AA.A2.value(k,j,i)=f.a2; %inesnity
            AA.A2.b1(k,j,i)=f.b2; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A2.FWHM(k,j,i) = f.c2*2*(2*log10(2))^0.5;
        
            AA.A3.value(k,j,i)=f.a3; %inesnity
            AA.A3.b1(k,j,i)=f.b3; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A3.FWHM(k,j,i) = f.c3*2*(2*log10(2))^0.5;
        else
            AA.A2.value(k,j,i)=f.a3; %inesnity
            AA.A2.b1(k,j,i)=f.b3; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A2.FWHM(k,j,i) = f.c3*2*(2*log10(2))^0.5;

            AA.A3.value(k,j,i)=f.a2; %inesnity
            AA.A3.b1(k,j,i)=f.b2; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A3.FWHM(k,j,i) = f.c2*2*(2*log10(2))^0.5;
        end
    
        
    elseif f.b2>f.b1 && f.b2>f.b3
        AA.A1.value(k,j,i)=f.a2; %inesnity
        AA.A1.b1(k,j,i)=f.b2; % peak positon for strain cacluation
        %Full Width Half Maxima (FWHM) from c which is related to the peak width
        AA.A1.FWHM(k,j,i) = f.c2*2*(2*log10(2))^0.5;
        if f.b1>f.b3
            AA.A2.value(k,j,i)=f.a1; %inesnity
            AA.A2.b1(k,j,i)=f.b1; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A2.FWHM(k,j,i) = f.c1*2*(2*log10(2))^0.5;
        
            AA.A3.value(k,j,i)=f.a3; %inesnity
            AA.A3.b1(k,j,i)=f.b3; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A3.FWHM(k,j,i) = f.c3*2*(2*log10(2))^0.5;
        else
            AA.A2.value(k,j,i)=f.a3; %inesnity
            AA.A2.b1(k,j,i)=f.b3; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A2.FWHM(k,j,i) = f.c3*2*(2*log10(2))^0.5;

            AA.A3.value(k,j,i)=f.a1; %inesnity
            AA.A3.b1(k,j,i)=f.b1; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A3.FWHM(k,j,i) = f.c1*2*(2*log10(2))^0.5;
        end
    
    
    else
        AA.A1.value(k,j,i)=f.a3; %inesnity
        AA.A1.b1(k,j,i)=f.b3; % peak positon for strain cacluation
        %Full Width Half Maxima (FWHM) from c which is related to the peak width
        AA.A1.FWHM(k,j,i) = f.c3*2*(2*log10(2))^0.5;
        if f.b1>f.b2
            AA.A2.value(k,j,i)=f.a1; %inesnity
            AA.A2.b1(k,j,i)=f.b1; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A2.FWHM(k,j,i) = f.c1*2*(2*log10(2))^0.5;
        
            AA.A3.value(k,j,i)=f.a2; %inesnity
            AA.A3.b1(k,j,i)=f.b2; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A3.FWHM(k,j,i) = f.c2*2*(2*log10(2))^0.5;
        else
            AA.A2.value(k,j,i)=f.a2; %inesnity
            AA.A2.b1(k,j,i)=f.b2; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A2.FWHM(k,j,i) = f.c2*2*(2*log10(2))^0.5;

            AA.A3.value(k,j,i)=f.a1; %inesnity
            AA.A3.b1(k,j,i)=f.b1; % peak positon for strain cacluation
            %Full Width Half Maxima (FWHM) from c which is related to the peak width
            AA.A3.FWHM(k,j,i) = f.c1*2*(2*log10(2))^0.5;
        end
    end  
