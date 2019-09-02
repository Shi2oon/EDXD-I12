function [Points]=SecondPassRef(RefScan,Ref_dir,doc2)
% 1st pass therotical
Eva         =   RefScan.Strain.eyy;   % absloute strains   
Eyy         =   abs(Eva - (min(Eva)+max(Eva))/2);
X           =   RefScan.Strain.X(1,:);
Y           =   RefScan.Strain.Y(:,1);
fwhmean     =   RefScan.fwhmmean;

%% points 2nd pass correction
NumberPo  = round(numel(fwhmean)*0.05);    % calculating numbar of random porints
[Points] = find2ndPoints(NumberPo,fwhmean,Eyy);

while length(Points(:,1)) <= 3 && NumberPo < numel(fwhmean)
    NumberPo = NumberPo+length(Points(:,1));
    [Points] = find2ndPoints(NumberPo,fwhmean,Eyy);
end

if Points(1,1) ~= [0 0]
% and plot them
close all;      FE = figure('Position',[50 100 1000 800]);  
axesFE = axes('Parent',FE);                 hold(axesFE,'all');  colormap(jet)
hdisp = pcolor(X,Y,Eva,'Parent',axesFE);    shading interp
hcont = contour(X,Y,Eva,10,'LineWidth',1,'LineColor',[0 0 0],'Parent',axesFE);
set(gcf,'position',[500,100,1050,700]); 
title(['Ref. Scan E_y_y with ' num2str(length(Points(:,1))) ...
    ' selcted Normalisation points (starred)'])
xlabel('stage x-position (mm)');        ylabel('stage y-position (mm)')
c = colorbar;                           c.Label.String = 'Strain';%labelling
for i=1:length(Points(:,1)) % find location for small points
    hold on; 
    plot(X(Points(i,2)),Y(Points(i,1)),'kp', 'MarkerSize', 15,'MarkerFaceColor','w');
end
hold off; path = fullfile(Ref_dir,[ num2str(doc2) ' 2nd pass selcted points.fig']); 
saveas(gcf,path); close all
end