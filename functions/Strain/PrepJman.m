function [err]=PrepJman (scan_numbers, doc2,dir,x1,y1,x2,y2,err,ALLDATA)

counter=1;
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

exx=griddata(x,y,Exx,X,Y,'cubic'); exx(:,1)=[]; exx(:,end)=[]; 
eyy=griddata(x,y,Eyy,X,Y,'cubic'); eyy(:,1)=[]; eyy(:,end)=[]; 
exy=griddata(x,y,Exy,X,Y,'cubic'); exy(:,1)=[]; exy(:,end)=[]; 
X(:,1)=[]; X(:,end)=[]; Y(:,1)=[]; Y(:,end)=[];

eval(sprintf('data_%d = [X(:) Y(:) exx(:) exy(:) eyy(:)];', doc1)); %data ready for J_MAN

counter=counter+1;
end

%% J-MAN overlap window and compare
counter=1;
pyxe_J_path = fullfile(dir.results,['\J-MAN ' num2str(scan_numbers(1)) '_'...
                num2str(scan_numbers(end))]);
mkdir(pyxe_J_path); %Make J-Man file

for doc1=scan_numbers
    
     if doc1~=doc2

%%load data
eval(sprintf('alldata=data_%d;', doc2))
x2=alldata(:,1);
y2=alldata(:,2);
Exx2=alldata(:,3);
Eyy2=alldata(:,4);
Exy2=alldata(:,5);

eval(sprintf('alldata=data_%d;', doc1))
x1=alldata(:,1);
y1=alldata(:,2);
Exx1=alldata(:,3);
Eyy1=alldata(:,4);
Exy1=alldata(:,5);

%%subtract
[Q,~]=size(x1);
for count=1:Q
    XX(count,1)=x1(count,1)-x2(count,1);
    YY(count,1)=y1(count,1)-y2(count,1);
    
    EXX(count,1)=Exx1(count,1)-Exx2(count,1);
    EYY(count,1)=Eyy1(count,1)-Eyy2(count,1);
    EXY(count,1)=Exy1(count,1)-Exy2(count,1);
end

%%check
err.ZeroXX (counter) = mean(XX);
err.ZeroYY (counter)= mean(YY);

alldata = [x1(:) y1(:) EXX(:) EYY(:) EXY(:)];

%% Removing NaNs
[D,~]=size (alldata); 
for i=D:-1:1
    if alldata (i,3)<100
    else 
        alldata(i,:)=[];
    end
end

%% Saving
     pyxe_D_path = fullfile(pyxe_J_path,[num2str(doc1) '0' num2str(doc2)]);
     save(pyxe_D_path, 'alldata','err')

     counter=counter+1;
     end

end