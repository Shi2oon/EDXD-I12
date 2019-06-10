%Finely intrepolated graph (smooth)
function [ALLDATA]=Interp(scan_numbers,dir,CB,ALLDATA)

counter=1;
for doc1=scan_numbers
alldata=ALLDATA{counter};
x=alldata(:,1);
y=alldata(:,2);
Exx=alldata(:,3);
Eyy=alldata(:,4);
Exy=alldata(:,5);

xLin=linspace(min(x),max(x),100);
yLin=linspace(min(y),max(y),100);
[X,Y]=meshgrid(xLin,yLin);

exx=griddata(x,y,Exx,X,Y,'cubic');
    plot_strain2(CB.minExx, CB.maxExx,X, Y,exx,'E_x_x',doc1,...
        dir.specific{counter},' Interpolted');
       
eyy=griddata(x,y,Eyy,X,Y,'cubic');
    plot_strain2(CB.minEyy, CB.maxEyy,X, Y,eyy,'E_y_y',doc1,...
        dir.specific{counter},' Interpolted');
        
exy=griddata(x,y,Exy,X,Y,'cubic');
    plot_strain2(CB.minExy, CB.maxExy,X, Y,exy,'E_x_y',doc1,...
        dir.specific{counter},' Interpolted');
    
ALLDATA{counter} = [X(:) Y(:) exx(:) eyy(:) exy(:)];
counter=counter+1;
end