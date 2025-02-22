function outputcell = outputs( weightcell,input)
input(1,end+1)=0.9;
[~,jwc]=size(weightcell);
for i=1:jwc
    if i==1
        temp=input*weightcell{i};
        temp=sgm(temp,0);
        temp(1,end+1)=0.9;
        outputcell{i}=temp;
    else
        temp=outputcell{i-1}*weightcell{i};
        temp=sgm(temp,0);
        if i~=jwc
            temp(1,end+1)=0.9;
            outputcell{i}=temp;
        else
           outputcell{i}=temp;
        end
    end
end
end

