function [AllScans,aa,RefScan,dir] = CalcRef(RefScan,dir,AllScans,aa,Q,scan,fk)
if RefScan ~= 'Theoretical'
%% loading
    dir.specific{2}= fullfile(dir.result,[num2str(RefScan) ' Reference']);  
    fprintf('Reference scan %d is loaded ...',RefScan);
    mkdir(dir.specific{2});
    dir.file = fullfile(dir.scan,[num2str(RefScan) '.nxs']);
    dir.Excel = fullfile(dir.specific{2},[num2str(RefScan) ' ys Intensity.xlsx']);
    
    dir.Dataset = '/entry1/EDXD_elements/data';
    Data = h5read(dir.file,dir.Dataset);
    dir.qDataset = '/entry1/EDXD_elements/edxd_q';
    qData = h5read(dir.file,dir.qDataset);
    
%% main body
[~,~,y,~]=size(Data); y=(1:y)'; x=y; dir.x=x;dir.y=y; %becuase there is no x nor y for it
    [AllScans,aa] = calcAll(AllScans,Data,qData,aa,Q,y,x,RefScan,2,dir,scan);

fprintf(' and completed\n');

elseif RefScan=='Theoretical'
    RefScan   = 999; % arbitrary name
    for peak=1:Q.NumberOfPeaks
        for k=1:fk
            eval(sprintf('aa.Ref.b%d(k) = Q.theory(peak);',peak));
            eval(sprintf('aa.a%d.Dmean(2,k) = Q.theory(peak);',peak));
        end
    end
    fprintf('Theoretical Reference is calculated and completed\n');
else
    clc;
    fprintf('make **SURE** you included the right reference or spelled *Theoretical*\n');
    fprintf('correctly or finally check if all files, including the refernce\n');
    fprintf(' are in the same directory\n');
end