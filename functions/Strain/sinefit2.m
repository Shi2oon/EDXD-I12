function [f] = sinefit2(x, y,TH)
%SINEFIT fits a sine curve of the form y=a*sin((2*x)+b+(pi/2))+c to the
%data x and y

%   sinefit(x,y,toggleplot) fits a sine curve of the form
%   y=a*sin((2*x)+b+(pi/2))+c to the data x and y.
%
%       Arguments:
%           x
%           y
%
%       Returns:
%           f1
%                General model:
%                  f1(x) = a*sin((2*x)+b+(pi/2))+c
%                  Coefficients (with 95% confidence bounds):
%                    a
%                    b
%                    c

f1=fit(x,y,'fourier1','Exclude',abs(y)>trimmean(abs(y),50)*TH); 
f.exx = f1.a0+f1.a1;
f.eyy = f1.a0-f1.a1;
f.exy = 2*f1.b1;

% f.a0  = f1.a0; 
% f.a1  = f1.a1;
% f.b1 = f1.b1;
end