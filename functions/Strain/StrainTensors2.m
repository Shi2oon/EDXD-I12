function [Strain] = StrainTensors2(scan,TH)
%STRAINTENSOR calculates the strain tensor at each measurement point by
%fitting a sinusoid to the 23 detector strains.

%   strainTensor(scan) calculates the strain at each point by fitting a
%   sinusoid to the detector strain (demaps) (calls the sinefit function)
%                   a*sin((2*x)+b+(pi/2))+c
%
%       Arguments:
%           scan
%                 diffractionData: [4-D double]
%                              sz: [4096 24 ydimension xdimension]
%                            xmap: [ydimension x xdimension double]
%                            ymap: [ydimension x xdimension double]
%                            xvec: [1 x xdimension double]
%                            yvec: [1 x ydimension double]
%                          number: scan number
%                           qmaps: [23 x ydimension x xdimension double]  
%                             ref: [1x1 struct]                           
%                          demaps: [23 x ydimension x xdimension double]
%
%       Returns:
%             maxPrincipalStrain: [ydimension x xdimension double]
%             minPrincipalStrain: [ydimension x xdimension double]
%                 PrincipalAngle: [ydimension x xdimension double]
%                            exx: [ydimension x xdimension double]
%                            eyy: [ydimension x xdimension double]
%                            exy: [ydimension x xdimension double]
%
%       Function Calls:
%           sinefit

[fk,fj,fi]  =   size(scan);
theta       =   linspace(0,pi,fk)'; % x = angle([1,2,...,23])

for i = 1:fi % loop through x-indices
    for j = 1:fj % loop through y-indices
        f1 = sinefit2(theta,scan(:,j,i),TH);
        Strain.exx(j,i) = f1.exx;
        Strain.eyy(j,i) = f1.eyy;
        Strain.exy(j,i) = f1.exy;
    end
end

