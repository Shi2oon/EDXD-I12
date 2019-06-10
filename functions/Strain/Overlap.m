%finding data window, data to process find common overlap window
function [x1,y1,x2,y2,path,ALLDATA]=Overlap (scan_numbers,dir,CB,ALLDATA)

counter=1;
for doc1=scan_numbers
alldata=ALLDATA{counter};

x=alldata(:,1);
y=alldata(:,2);

x1(counter)=min(x);
x2(counter)=max(x);
y1(counter)=min(y);
y2(counter)=max(y);

counter=counter+1;
end

%remove zeros
x1(x1==0) = [];
x2(x2==0) = [];
y1(y1==0) = [];
y2(y2==0) = [];

%% create overlap
counter=1;
path = fullfile(dir.results,['\Strain Overlap & Compare ' num2str(scan_numbers(1))...
            '_' num2str(scan_numbers(end))]); mkdir(path); %Make Overlap file
        
for doc1=scan_numbers
alldata=ALLDATA{counter};

x=alldata(:,1);
y=alldata(:,2);
Exx=alldata(:,3);
Eyy=alldata(:,4);
Exy=alldata(:,5);

xLin=linspace(max(x1),min(x2),100);
yLin=linspace(max(y1),min(y2),100);
[X,Y]=meshgrid(xLin,yLin);

exx=griddata(x,y,Exx,X,Y,'cubic');  
eyy=griddata(x,y,Eyy,X,Y,'cubic');
exy=griddata(x,y,Exy,X,Y,'cubic'); 

ALLDATA{counter}= [X(:) Y(:) exx(:) eyy(:) exy(:)];

%% plotting
[exx,eyy,exy,X,Y]=findNaNs3 (exx,eyy,exy,X,Y);

    plot_strain2(CB.minExx, CB.maxExx,X, Y,exx,'E_x_x',doc1,...
        path,' Overlap');
       
    plot_strain2(CB.minEyy, CB.maxEyy,X, Y,eyy,'E_y_y',doc1,...
        path,' Overlap');
        
    plot_strain2(CB.minExyO, CB.maxExyO,X, Y,exy,'E_x_y',doc1,...
        path,' Overlap');
    
counter=counter+1;
end