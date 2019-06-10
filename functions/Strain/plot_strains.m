function plot_strains(Strain,doc1,dir)

%ref = scan.ref;
xmap = Strain.X;
ymap = Strain.Y;
exx = Strain.exx;
eyy = Strain.eyy;
exy = Strain.exy;

% % max and min colormap values for plots
% c_limits.cmax = max(vertcat(exx(:),eyy(:),exy(:)));
% c_limits.cmin = min(vertcat(exx(:),eyy(:),exy(:)));

% Plot Max. principal strain
% plot_strain(c_limits,xmap,ymap,eyy,'E_y_y',doc1,dir);
plot_strain(xmap,ymap,exx,'E_x_x',doc1,dir);
plot_strain(xmap,ymap,eyy,'E_y_y',doc1,dir);
plot_strain(xmap,ymap,exy,'E_x_y',doc1,dir);

end

