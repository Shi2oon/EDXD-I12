% function to get the EDXD raw data, plot, and save it at .mat

function [CB,dir,ALLDATA]=GetData(scan_numbers,doc2, dir) 

count=1;
for doc1=scan_numbers
    pyxe_d_path = fullfile(dir.specific{count}...
        ,[num2str(doc1) ' Mean Intensity.mat']);
    
     % Data
     load(pyxe_d_path)
     ALLDATA{count}=alldata;
     x = squeeze(alldata(:,1)); X=x(1,:);
     y = squeeze(alldata(:,2)); Y=y(:,1);
     Exx = squeeze(alldata(:,3)); 
     minExx(count)=min(min(Exx)); maxExx(count)=max(max(Exx));
     Eyy = squeeze(alldata(:,4));
     minEyy(count)=min(min(Eyy)); maxEyy(count)=max(max(Eyy));
     Exy = squeeze(alldata(:,5));
     minExy(count)=min(min(Exy)); maxExy(count)=max(max(Exy));

     if doc1==doc2
         dir.doc2=dir.specific{count};
         minExx2=min(min(Exx)); maxExx2=max(max(Exx));
         minExy2=min(min(Exy)); maxExy2=max(max(Exy));
         minEyy2=min(min(Eyy)); maxEyy2=max(max(Eyy));
     end  

count=count+1;  
 end

% plotting colormap limits 
CB.minExx=min(minExx); CB.maxExx=max(maxExx);
CB.minEyy=min(minEyy); CB.maxEyy=max(maxEyy);
CB.minExy=min(minExy); CB.maxExy=max(maxExy);

% overlap plotting colormap limits
CB.minExxO=(CB.minExx-maxExx2); CB.maxExxO=(CB.maxExx-minExx2);
CB.minExyO=(CB.minExy-maxExx2); CB.maxExyO=(CB.maxExy-minExy2);
CB.minEyyO=(CB.minEyy-maxExx2); CB.maxEyyO=(CB.maxEyy-minEyy2);