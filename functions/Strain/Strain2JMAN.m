% MATLAB program for EDXD recieved after pyxe processing
% the program produce filed raw data, find and correct for a common scan
% window, produce graphs for strain in Exx, Eyy, and Exy and the full
% deviation on an excel sheet file. The program remove residual stress and
% also detect and calcuate the crak increment in x and y
% for residual stress removal note the K which will be calcualted by J-MAN
% will be the Delta K which equals Actuall scan K - Reference scan K
% The program is relatively long due to not using any functions 
% and just make everything straight forward so feel free to edit
% Written by Abdalrhaman Mohamed as part of DPhil/PhD project 
% at University of Oxford. Abd.Mohamed@stx.ox.ac.uk or abdo.aog@gmail.com
% Last updated and tested 30th January 2019
% User will be asked fot the Reference Scan to be used for Comparison  
% Acknowledgements to Phil Earp 
function Strain2JMAN(scan_numbers,doc2, dir)
%% 1. Get the EDXD raw data (strain & fwhm), plot, and save it in a new file
[CB,DIR,ALLDATA]=GetData(scan_numbers,doc2, dir) ;

%% 3. Finely intrepolated graph (smooth) .. produce plots and data sets
[ALLDATA2]=Interp(scan_numbers,DIR,CB,ALLDATA);

%% 4. finding data window, data to process find common overlap window .. produce plots and data set
[x1,y1,x2,y2,pyxe_Over_path,ALLDATA2]=Overlap(scan_numbers,DIR,CB,ALLDATA2);

%% 5. Compare Interpolated overlap .. produce plots and data set 
[err]=Compare(scan_numbers, doc2,x1,y1,x2,y2,pyxe_Over_path,CB,ALLDATA2);

%% 6. Prepreation for J-MAN .. produce data set ready to be usd in Matlab
[~]=PrepJman(scan_numbers, doc2,DIR,x1,y1,x2,y2,err,ALLDATA);
fprintf('All scans mean fitting error is = %.1f percent',err.meanXY);
