% code to generate 9 different test and training data
% by randomly selecting from the given data

% I saved the data in 2.xlsx
completeData = importdata('2.xlsx');

completeData(:,1)=zscore(completeData(:,1));
completeData(:,2)=zscore(completeData(:,2));
maxl=max(completeData(:,1));
minl=min(completeData(:,1));
maxp=max(completeData(:,2));
minp=min(completeData(:,2));

%minmax.xls to generate the boundary in KNN
xlswrite('minmax.xls',[maxl,minl,maxp,minp]);

for c=1:9

rand20 = randperm(300,60); %test data
rem80=[];

for i=1:300
    if(~ismember(i,rand20))
         rem80(end+1)=i;
    end;
end

rand20arr=[];
rem80arr=[];

for i=1:60
      rand20arr(end+1,:)=completeData(rand20(i),:);  
end

for i=1:240
      rem80arr(end+1,:)=completeData(rem80(i),:);  
end

filenametest=strcat('testdata',int2str(c));
filenametrain=strcat('traindata',int2str(c));
disp(filenametest);
xlswrite(filenametest,rand20arr);
xlswrite(filenametrain,rem80arr);
end
