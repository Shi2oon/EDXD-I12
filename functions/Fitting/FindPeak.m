function [aa]= FindPeak(aa,Q,AA)
%% find the corresponding peak
for peak=1:Q.NumberOfPeaks
eval(sprintf('aa.qposition(peak)=trimmean(trimmean(trimmean(AA.A%d.b1,50),50),50);',peak));
   for peaki=1:Q.NumberOfPeaks
        if  aa.qposition(peak) > Q.q_guess(peaki)*(1-Q.nn) ...
                && aa.qposition(peak) < Q.q_guess(peaki)*(1+Q.nn)
            aa.Qposition(peak)=Q.PeakPosition(peaki);         
        end
   end
end

aa.Qposition=flip(aa.Qposition);