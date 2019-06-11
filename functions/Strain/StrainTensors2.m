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
        f1{j,i} = sinefit2(theta,scan(:,j,i),TH);
        Strain.exx(j,i) = f1{j,i}.exx;
        Strain.eyy(j,i) = f1{j,i}.eyy;
        Strain.exy(j,i) = f1{j,i}.exy;
        
        %%%%%%%%%%%%%%%%%%%%%%%% simialr results as above
%         % Mohr's Circle Construction to calculate exx, eyy, exy
%         maxPrincipal(j,i)     = f1{j,i}.a0 + f1{j,i}.a1; % Max principal strain
%         minPrincipal(j,i)     = f1{j,i}.a0 - f1{j,i}.a1; % Min principal strain
%         PrincipalAngle(j,i) = pi - f1{j,i}.b1/2; % Detector angle of maximum normal strain
%         C(j,i)   = (maxPrincipal(j,i) + minPrincipal(j,i))./2;
%         R(j,i)   = (maxPrincipal(j,i) - minPrincipal(j,i))./2;
    end
end

% eXX = C + R.*cos(2*PrincipalAngle);     Strain.eXX = eXX;
% eYY = C - R.*cos(2*PrincipalAngle);     Strain.eYY = eYY;
% eXY = R.*sin(2*PrincipalAngle);         Strain.eXY = eXY;
% 
% %% Plot Mohr's Circle
% close all
% i = randi([1 fj],1);
% j = randi([1 fi],1);
% circle(C(i,j),0,R(i,j)); % circle
% set(0,'defaultAxesFontSize',15); set(0,'DefaultLineMarkerSize',12)
% set(gcf,'position',[500,100,1050,700])
% set(gca,'Ydir','reverse')
% hold on
% plot(eXX(i,j),eXY(i,j),'p','DisplayName','[e_x_x  e_x_y]') % (exx,exy)
% plot(eYY(i,j),-eXY(i,j),'p','DisplayName','[e_y_y –e_x_y]') % (eyy,-exy)
% plot(C(i,j),0,'o','HandleVisibility','off') % centre
% plot(maxPrincipal(i,j),0,'d','DisplayName','max. Principal Strain') % (e1)
% plot(minPrincipal(i,j),0,'d','DisplayName','min. Principal Strain') % (e2)
% plot([eXX(i,j) eYY(i,j)],[eXY(i,j) -eXY(i,j)],'HandleVisibility','off') % angled line
% title('Mohr^{\prime}s Circle');
% hold off
% axis equal
% ax = gca;
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';
% legend('Location','northeastoutside')