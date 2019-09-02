% This is a matlab program writtne for processing EDXD data obtained from EDXD-I12
% the program takes raw EDXD data and process them to get normalised XRD
% specturm, FWHM and crack popagation, elastic strain tensors and delta
% elastic strain tensors between two subsets with overlap fitting (to be 
% used for J-intergal calculations) .. The code is very flexiable and can be 
% used without normalisation nor reference (un-strained) scan 

%%%%%%%%%% ALL SCANS NAMES NEED TO BE NUMBERS %%%%%%%%%%%%%%%%%%%%%

% this code is written by Abdalrhaman Mohamed abd.mohamed@stx.ox.ac.uk or 
% abdo.aog@gmail.com as part of DPhil/PhD in the Univeristy of Oxford, Dept. of Materials 

%% Directors
close all;      clear;      clc;     	warning('off');	
set(0,'defaultAxesFontSize',25);        addpath(genpath(pwd)); 
fprintf('A code to analyise EDXD-I12 data written by Abdalrhaman M. abdo.aog@gmail.com\n\n');
dir.scan   = 'X:\EE 13579 Diamond Light Source\EDXD\1. EDXD rawdata'; %raw data directory
dir.result = 'X:\EE 13579 Diamond Light Source\Diamond EE 13579\Strain Analysis 7'; %result directory
mkdir(dir.result);

%% files to process
% scan.scan    = [66842,66844,66845,66846,66850,66852,66853,66854,66855,66856,66857];  
% scan.doc2    = 66842; 
% scan.scan    = [66881,66882,66883,66884,66885,66886,66887];                           
% scan.doc2    = 66887; 
scan.scan    = [66826,66827,66828,66829,66830,66831,66833,66834,66838,66839,66840];   
scan.doc2    = 66826; % strain reference (for delta strain cacluation)
scan.Calib   = 66892;  % calibration/normalisation ciera scan, if not available then 'NO'
scan.ref     = 'Theoretical';  % number of unstrained scan(s), if not avilable then 'Theoretical'  
fk           = 23;       % number of detectors;
scan.TH      = 3;        % fold of tolerance 1 to 5 of the mean along values in 1 point
scan.CalibsC = [1,length(scan.Calib)]; % this is useful if you're using a range of calibration scans

%% Peak fitting parameters
Q.PeakPositionS = [1 1 0; 2 0 0; 2 1 1]; % peaks planes h k l
Q.PeakPosition  = [110, 200, 211]; %% put the peaks hkl coordinates
Q.latticePar    = 2.866;             %lattice parameter, for Fe=2.856;
[Q]             = Qsss(Q); %calculate values related to peaks and fittings tolearnce

%% calculate Calibration Factor and reference
 tic; [scan_numbers,AllScans,dir,doc2,~] = DiffSpect(scan,Q,dir,fk);
 if scan.ref == 'Theoretical'       % points for 2nd pass Yp(:,1), Xp(:,2)
    [Points] = SecondPassRef(AllScans.RefScan,dir.results,scan.doc2); 
    [scan_numbers,AllScans,dir,~] = SecondPass(scan,Q,dir,Points,fk);
end
T(1)=toc;
%% FWHM analysis
close all; tic;     dir.FWHM = fullfile(dir.results,'FWHM Analysis');    mkdir(dir.FWHM);  
%FwhmForTexture(scan_numbers,dir.FWHM,AllScans,Q.NumberOfPeaks,aa,doc2); for each peak
FwhmAll(scan_numbers, dir.FWHM, AllScans, doc2);    % for weighted FWHM values
T(2) = toc;         fprintf('%d files done in %1.f seconds\n\n',...
                            length(scan_numbers),T(2));
                        
 %%   Strain Analysis
dir.specific(:,1)=[];                dir.specific(:,1)=[]; tic; % removing ref. and calib. scan dir
Strain2JMAN(scan_numbers,doc2,dir);  %calculate strain
T(3)=toc;     fprintf('\n%d files were Strain processed in %1.f seconds\n\n',...
                            length(scan_numbers),T(3));

fprintf('All completed in %.1f hours for total of %d files\n\n',...
    sum(T)/3600, length(scan_numbers));