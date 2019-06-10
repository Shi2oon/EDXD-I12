function [scan_numbers,AllScans,dir,T] = SecondPass(scan,Q,dir,Points,fk)

if Points(1,1) ~= [0 0] % no points were found
    clc;            credits;        
    fprintf('2nd pass for Theoretical results optimizations\n');
    
    % clibartion
    tic;    [aa,scan.Calib,AllScans] = CalcCalb(scan.Calib,dir,fk,scan.CalibsC,Q); 
    T(1)    = toc; 
    % calculate the reference scan
    tic;    [aa.Ref,AllScans.CacledRef] = ref2nd(dir,Points,Q,aa.Factor,scan);
    T(2)    = toc;           

    fprintf('All calibration and Reference scans are done in %.1f seconds\n\n',...
    sum(T));     fprintf('Starts main body\n');
                    scan.ref = 999;
    %% Process Scans
    %normalisation and strain calcuations
    [scan_numbers,AllScans,dir,~,T(3)] = mainScan(scan,aa,dir,Q,AllScans,fk);

    T = sum(T);
else
    fprintf('\nNo un-strained points were found for strain normalisation .. proceed to resuls\n\n');
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
    tic;  [scan_numbers,AllScans,dir,~,~] = mainScan(scan,aa,dir,Q,AllScans,fk);
    T(3)  = toc;
    T     = sum(T);
end

