   function [value,b1,FWHM]=SortedValues(f,peak)
      eval(sprintf('value=f.a%d;',peak)); %inesnity
      eval(sprintf('b1=f.b%d;',peak)); % peak positon for strain cacluation
      %Full Width Half Maxima (FWHM) from c which is related to the peak width
      eval(sprintf('FWHM = f.c%d*2*(2*log10(2))^0.5;',peak));
   end