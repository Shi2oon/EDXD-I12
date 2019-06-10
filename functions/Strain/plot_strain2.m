function plot_strain2(cmin, cmax,xmap, ymap,data,title_string,doc1,path,operation)
%PLOT_STRAIN_SUBPLOT Summary of this function goes here
%   Detailed explanation goes here
warning off
%contourf(xmap,ymap,data)

  FE = figure('Position',[50 100 1000 800]);
  axesFE = axes('Parent',FE);
  hold(axesFE,'all');
 %plot strain contours
  colormap(jet)
%   imagesc(gl.dy)
  hdisp = pcolor(xmap,ymap,data,'Parent',axesFE);
          shading interp
  hcont = contour(xmap,ymap,data,10,'LineWidth',1,'LineColor',...
      [0 0 0],'Parent',axesFE);

set(gcf,'position',[500,100,1050,700]); caxis([cmin cmax])
title([title_string ' map for scan ' num2str(doc1) operation])
xlabel('stage x-position (mm)');    ylabel('stage y-position (mm)')
c = colorbar;                       c.Label.String = 'Strain';%labelling

path = fullfile(path,[title_string '_' num2str(doc1) operation '.fig']);
saveas(gcf,path);   close all
