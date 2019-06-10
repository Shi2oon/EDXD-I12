function [f1] = sinefit(x, y)
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


% define fitting function
sineEqn = 'a*sin((2*x)+b+(pi/2))+c'; % sine
% define starting values of coefficients [a b c]
startPoints = [3 0 mean(y)];
lower = [0 -pi -inf];
upper = [inf pi inf];

f1 = fit(x,y,sineEqn,'Start',startPoints,'Lower',lower,'Upper',upper);
end
% if toggleplot
%     plot(f1,x,y)
%     figure; polar(x,y+0.005); hold on; polar(x,ones(23,1)*0.005); hold off
% end