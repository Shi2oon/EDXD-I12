function [Strain] = StrainTensors(scan)
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

[fk,fj,fi]=size(scan);
theta = linspace(0,pi,fk)'; % x = angle([1,2,...,23])
fittingParameters_a = zeros(fj,fi);
fittingParameters_b = zeros(fj,fi);
fittingParameters_c = zeros(fj,fi);

tic
parfor i = 1:fi % loop through x-indices
    for j = 1:fj % loop through y-indices
        f1 = sinefit(theta,scan(:,j,i));
        fittingParameters_a(j,i) = f1.a;
        fittingParameters_b(j,i) = f1.b;
        fittingParameters_c(j,i) = f1.c;
    end
end

Strain.maxPrincipal = fittingParameters_c + fittingParameters_a; % Max principal strain
Strain.minPrincipal = fittingParameters_c - fittingParameters_a; % Min principal strain
Strain.PrincipalAngle = pi - fittingParameters_b/2; % Detector angle of maximum normal strain

% Mohr's Circle Construction to calculate exx, eyy, exy
C = (Strain.maxPrincipal + Strain.minPrincipal)./2;
R = (Strain.maxPrincipal - Strain.minPrincipal)./2;
Strain.exx = C + R.*cos(2*Strain.PrincipalAngle);
Strain.eyy = C - R.*cos(2*Strain.PrincipalAngle);
Strain.exy = R.*sin(2*Strain.PrincipalAngle);

% Plot Mohr's Circle
close all
i = randi([1 fj],1);
j = randi([1 fi],1);
circle(C(i,j),0,R(i,j)); % circle
set(0,'defaultAxesFontSize',15); set(0,'DefaultLineMarkerSize',12)
set(gcf,'position',[500,100,1050,700])
set(gca,'Ydir','reverse')
hold on
plot(Strain.exx(i,j),Strain.exy(i,j),'p','DisplayName','[e_x_x  e_x_y]') % (exx,exy)
plot(Strain.eyy(i,j),-Strain.exy(i,j),'p','DisplayName','[e_y_y –e_x_y]') % (eyy,-exy)
plot(C(i,j),0,'o','HandleVisibility','off') % centre
plot(Strain.maxPrincipal(i,j),0,'d','DisplayName','max. Principal Strain') % (e1)
plot(Strain.minPrincipal(i,j),0,'d','DisplayName','min. Principal Strain') % (e2)
plot([Strain.exx(i,j) Strain.eyy(i,j)],[Strain.exy(i,j) -Strain.exy(i,j)],'HandleVisibility','off') % angled line
title('Mohr^{\prime}s Circle');
hold off
axis equal
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
legend('Location','northeastoutside')


