function [scan_numbers,AllScans,dir,doc2,T] = DiffSpect(scan,Q,dir,fk)

% calculate the calibration/normalisation
tic;    [aa,scan.Calib,AllScans] = CalcCalb(scan.Calib,dir,fk,scan.CalibsC,Q);  
T(1)  = toc; 

% calculate the reference scan
tic;    [AllScans,aa,scan.ref,dir] = CalcRef(scan.ref,dir,AllScans,aa,Q,scan,fk);
T(2)  = toc;           

fprintf('All calibration and Reference scans are done in %.1f seconds\n\n',...
      sum(T));     fprintf('Starts main body\n');

%% Process Scans
%normalisation and strain calcuations
scan_numbers = scan.scan;                       doc2 = scan.doc2; 
scan_numbers(scan_numbers == scan.Calib) = [];
scan_numbers(scan_numbers == scan.ref)   = [];
dir.results = [dir.result '\' num2str(min(scan_numbers)) ' to '...
                num2str(max(scan_numbers))];       mkdir(dir.results);
dir.Excel   = fullfile(dir.results,[num2str(min(scan_numbers)) ' to ' ...
                num2str(max(scan_numbers)) ' ys Intensity.xlsx']);
tic;        
if scan.ref == 999 %using theroetical values   
    fprintf('Reference scan (%d) is being processed for the 2nd pass\n',scan.doc2);
    [AllScans,~,~] = CalcScan(AllScans,aa,Q,scan.doc2,3,dir,scan); 
    fprintf('correction of peaks position value .. done in .2f minutes\n',toc/60);
else
    [scan_numbers,AllScans,dir,~,~] = mainScan(scan,aa,dir,Q,AllScans,fk);
end
T(3)  = toc;
T     = sum(T);
