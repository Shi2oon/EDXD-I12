%calculate tolearnce for peak postion
function [valueout]=findnn(valuein)

for iv=1:length(valuein)
    if iv+1<=length(valuein)
        valueout(iv)=min(abs(valuein(iv)-valuein(iv+1))/valuein(iv), ...
                        abs(valuein(iv)-valuein(iv+1))/valuein(iv+1));
    elseif length(valuein)==1
        valueout=0.9;
    end
end

valueout=min(valueout);
end