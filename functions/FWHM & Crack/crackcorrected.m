function [TCr]=crackcorrected(TableExy,TableFWHM,doc2)
%% fwhm 
TableFWHM = table2array(TableFWHM); 
for i=1:length(TableFWHM(:,1))
    if doc2==TableFWHM(i,1);        count=i;        end
end
TableFWHM = [TableFWHM(:,1),TableFWHM(:,3),TableFWHM(:,4)];

%% Exy
TableExy = table2array(TableExy);
TableExy = [TableExy(:,1),TableExy(:,3),TableExy(:,4)];

%% compare
counter=0;
for i=1:length(TableFWHM(:,1))
    if i~=count
        if abs(TableFWHM(i,2)-TableExy(i-counter,2)) || abs(TableFWHM(i,3)-TableExy(i-counter,3))
            TCr(i,1) = TableFWHM(i,1);                              % file name
            TCr(i,2) = (TableFWHM(i,2)+TableExy(i-counter,2))/2;    % x coordinate
            TCr(i,3) = (TableFWHM(i,3)+TableExy(i-counter,3))/2;    % y coordinate
        else
            TCr(i,1) = TableFWHM(i-counter,1);                      % file name
            TCr(i,2) = TableFWHM(i-counter,2);                      % x coordinate
            TCr(i,3) = TableFWHM(i-counter,3);                      % y coordinate
        end
    else
        TCr(i,:) = [TableFWHM(i,1),TableFWHM(i,2),TableFWHM(i,3)];
        counter=1;
    end
end