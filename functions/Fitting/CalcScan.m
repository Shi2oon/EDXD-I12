function [AllScans,aa,dir] = CalcScan(AllScans,aa,Q,doc1,count,dir,scan)
%% loading
    dir.specific{count}= fullfile(dir.results,num2str(doc1)); 
    mkdir(dir.specific{count});
    dir.file = fullfile(dir.scan,[num2str(doc1) '.nxs']);
    
    dir.Dataset = '/entry1/EDXD_elements/data';
    Data = h5read(dir.file,dir.Dataset);
    dir.qDataset = '/entry1/EDXD_elements/edxd_q';
    qData = h5read(dir.file,dir.qDataset);
    dir.x = '/entry1/EDXD_elements/ss2_x';
    dir.x = h5read(dir.file,dir.x);
    dir.x=dir.x.*-1; x = squeeze(dir.x); x=x(1,:);
    dir.y = '/entry1/EDXD_elements/ss2_y';
    dir.y = h5read(dir.file,dir.y);
    dir.y=dir.y.*-1; y = squeeze(dir.y); y=y(:,1);
    
%% main body
AllScans.scan=0;
[AllScans,aa]=calcAll(AllScans,Data,qData,aa,Q,y,x,doc1,count,dir,scan);