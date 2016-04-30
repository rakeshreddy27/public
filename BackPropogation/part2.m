%To define number of layers 
%and nodes in each layer
layerSizes=[784,125,10];
%LayerSizes size-1
learningRates=[0.1,0.1];
%LayerSizes size-1
momentums=[0.9,0.9];
%set number of epochs
epochs=200;

[~,jls]=size(layerSizes);
%create a cell of arrays for weights in x+1,y format 
% x+1 to accommodate the bias
for i=2:jls
    x=layerSizes(i-1);
    y=layerSizes(i);
    weightcell{i-1}=rand(x+1,y)/10;
    %cell to store previous deltas to calculate momentum
    prevdeltacell{i-1}=zeros(x+1,y);
 end

 
data= load('MNISTnumImages5000.txt');
values=load('MNISTnumLabels5000.txt');

train4000=randperm(5000,4000);
test1000=[];
for i=1:5000
    if(~ismember(i,train4000))
         test1000(end+1)=i;
    end;
end

valuearr=[];
for i=1:5000
    temp=values(i);
    temp1=zeros(1,10);
    temp1(temp+1)=1;
    valuearr(i,:)=temp1;  
end

traindata=[];
trainoutput=[];
testdata=[];
testoutput=[];

for i=1:1000
      testdata(end+1,:)=data(test1000(i),:); 
      testoutput(end+1,:)=valuearr(test1000(i),:); 
end

for i=1:4000
      traindata(end+1,:)=data(train4000(i),:); 
      trainoutput(end+1,:)=valuearr(train4000(i),:); 
end



error=[];
obtained=[];
original=[];
count=0;
 for k=1:4000
 output=outputs(weightcell,traindata(k,:));
 [~,q]=max(output{end});
 [~,q1]=max(trainoutput(k,:));
 obtained(end+1)=q;
 original(end+1)=q1;
 if q~=q1
    count=count+1;
 end
 end
  error(end+1)=(count*100)/4000;




for j=1:2000
    disp(j);
    x=randperm(4000,200);
    trda=traindata(x,:);
    trot=trainoutput(x,:);
for i=1:200
    output=outputs(weightcell,trda(i,:));
    del=delta(data(i,:),weightcell,output,trot(i,:),learningRates);
    for s=1:jls-1
     weightcell{s}=weightcell{s}-(del{s}+momentums(s)*prevdeltacell{s});
    end
    prevdeltacell=del;
end

if rem(j,10)==0
 obtained=[];
original=[];
count=0;
 for k=1:4000
 output=outputs(weightcell,traindata(k,:));
 [~,q]=max(output{end});
 [~,q1]=max(trainoutput(k,:));
 obtained(end+1)=q;
 original(end+1)=q1;
 if q~=q1
    count=count+1;
 end
 end
 error(end+1)=(count*100)/4000;
end
end



obtained=[];
original=[];
count=0;
 for k=1:1000
 output=outputs(weightcell,testdata(k,:));
 [~,q]=max(output{end});
 [~,q1]=max(testoutput(k,:));
 obtained(end+1)=q;
 original(end+1)=q1;
 if q~=q1
    count=count+1;
 end
 end

 
 testerror=(count*100)/1000;
%{
plot(0:10:2000,error,'LineWidth',2);
title ('Training Error');
xlabel('Epoch Numbers');
ylabel('Training Error');
axis([1 2000 0 100]);
 %}
disp(count);

