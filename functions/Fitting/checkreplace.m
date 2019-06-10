function [Data]=checkreplace(Data,tol)
% the function check consisitency in the peak and FWHM calcuations
% tol is threshold
[fk,fj,fi]=size(Data); 


if fi~=1
for j=1:fj
    for i=1:fi
        I=zeros(1,fk);
        for k=1:fk
            if abs(Data(k,j,i))/trimmean(abs(Data(:,j,i)),50)>=tol
                I(k)=k;
            end
        end

        for k=1:fk
            if I(k)==0
                %do nothing
            elseif k~=fk
                if abs(I(k)-I(1+k))~=1 && k~=1
                    Data(k,j,i)=(Data(k-1,j,i)+Data(k+1,j,i))/2;
                elseif k<fk-1  && k~=1 && abs(I(k)-I(2+k))~=2  && k~=2
                        Data(k,j,i)=(Data(k-2,j,i)+Data(k+2,j,i))/2;
                elseif k<fk-2  && k~=1 && abs(I(k)-I(3+k))~=3  && k~=3 && k~=2
                        Data(k,j,i)=(Data(k-3,j,i)+Data(k+3,j,i))/2;
                elseif k==1 || k==2 || k==3
                    Data(k,j,i)=Data(k+(k==1)+(k==2)+(k==3),j,i);
                else
                    Data(k,j,i)=2*Data(k-1,j,i)-Data(k-2,j,i);
                end     
            else
                    Data(k,j,i)=2*Data(k-1,j,i)-Data(k-2,j,i);
            end
        end
    end
end

else
    for j=1:fj
        I=zeros(1,fk);
        for k=1:fk
            if abs(Data(k,j))/trimmean(abs(Data(:,j)),50)>=tol
                I(k)=k;
            end
        end

        for k=1:fk
            if I(k)==0
                %do nothing
            elseif k~=fk
                if abs(I(k)-I(1+k))~=1 && k~=1
                    Data(k,j)=(Data(k-1,j)+Data(k+1,j))/2;
                elseif k<fk-1  && k~=1 && abs(I(k)-I(2+k))~=2  && k~=2
                        Data(k,j)=(Data(k-2,j)+Data(k+2,j))/2;
                elseif k<fk-2  && k~=1 && abs(I(k)-I(3+k))~=3  && k~=3 && k~=2
                        Data(k,j)=(Data(k-3,j)+Data(k+3,j))/2;
                elseif k==1 || k==2 || k==3
                    Data(k,j)=Data(k+(k==1)+(k==2)+(k==3),j);
                else
                    Data(k,j)=2*Data(k-1,j)-Data(k-2,j);
                end     
            else
                    Data(k,j)=2*Data(k-1,j)-Data(k-2,j);
            end
        end
    end
end