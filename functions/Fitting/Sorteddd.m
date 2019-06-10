% a sort function that takes number of values and arrange them wether by
% max value or miniumim .. one thing to be caution about is that your
% values need to be inside a variable and named sort
function [valueout]=Sorteddd(valuein,valuesNo,typeby)
   
for peak=1:valuesNo
    eval(sprintf('c(peak) = valuein.sort%d;',peak));
end

z=c;
for peaki = 1:valuesNo
    if typeby == 'min'; C=min(z);    % arrange by min
    else;    C = max(z); end         % arrange by max
    
    [peak] = ind2sub(size(c),find(c==C));
    eval(sprintf('valueout(peaki) = valuein.sort%d;',peak));
    z = z(z~=C);
end
      
