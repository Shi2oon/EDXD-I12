% this function calcultes the delta strain between two scans 
function [err]=Compare (scan_numbers,doc2,x1,y1,x2,y2,pyxe_Over_path,CB,ALLDATA)
counters=1;
for doc1=scan_numbers 
    if doc1==doc2
        dirdoc2=counters;
    end
counters=counters+1;
end

counters=0;
for doc1=scan_numbers
  counters=counters+1;  
if doc1~=doc2

%% load data
alldata=ALLDATA{dirdoc2};

Y2=alldata(:,1);
X2=alldata(:,2);
Exx2=alldata(:,3);
Eyy2=alldata(:,4);
Exy2=alldata(:,5);

alldata=ALLDATA{counters};

X1=alldata(:,1);
Y1=alldata(:,2);
Exx1=alldata(:,3);
Eyy1=alldata(:,4);
Exy1=alldata(:,5);

%% subtract
[Q,~]=size(X1);
for count=1:Q
    XX(count,1)  = X1(count,1)-X2(count,1);
    YY(count,1)  = Y1(count,1)-Y2(count,1);
    
    Exx(count,1) = Exx1(count,1)-Exx2(count,1);
    Eyy(count,1) = Eyy1(count,1)-Eyy2(count,1);
    Exy(count,1) = Exy1(count,1)-Exy2(count,1);
end

%% check
err.ZeroX (counters) = mean(XX);
err.ZeroY (counters)= mean(YY);
error=trimmean([err.ZeroX(counters),err.ZeroY(counters)],50);

%% final figures
xLin=linspace(max(x1),min(x2));
yLin=linspace(max(y1),min(y2));
[X,Y]=meshgrid(xLin,yLin);

exx=griddata(X1,Y1,Exx,X,Y,'cubic');    
eyy=griddata(X1,Y1,Eyy,X,Y,'cubic');       
exy=griddata(X1,Y1,Exy,X,Y,'cubic');
    
[exx,eyy,exy,X,Y]=findNaNs3 (exx,eyy,exy,X,Y);

    plot_strain2(CB.minExxO, CB.maxExxO,X, Y,exx,'E_x_x',doc1,...
        pyxe_Over_path,[' Sub. from ' num2str(doc2)]);
    plot_strain2(CB.minEyyO, CB.maxEyyO,X, Y,eyy,'E_y_y',doc1,...
        pyxe_Over_path,[' Sub. from ' num2str(doc2)]);
    plot_strain2(CB.minExyO, CB.maxExyO,X, Y,exy,'E_x_y',doc1,...
        pyxe_Over_path,[' Sub. from ' num2str(doc2)]);   
    
alldata = [X(:) Y(:) exx(:) eyy(:) exy(:)];

%% Saving
pyxe_D_path = fullfile(pyxe_Over_path,[num2str(doc1) '_' num2str(doc2) '_Comparison']);
save(pyxe_D_path, 'alldata','error');
end
end
err.meanXY=trimmean([trimmean(err.ZeroX,50),trimmean(err.ZeroY,50)],50);