% simple perceptron code

trainerrorarr=[];
for z=1:9
filtest=strcat('testdata',int2str(z),'.xls');
filtrain=strcat('traindata',int2str(z),'.xls');
rand20arr=importdata(filtest);
rem80arr=importdata(filtrain);

epochs=0;
w0=rand(1);
w1=rand(1);
w2=rand(1);
b=1;
e=0.1;

percent=percentCorrect( w1,w2,w0,rem80arr);
disp(percent);
trainerror=[];

trainerror(end+1)=100-percent;

a=[];
maxper=0;
while epochs<=200 
    epochs=epochs+1;
    
 for k=1:240
     
     output=changeWeights(w1,w2,w0,rem80arr(k,:),e);
     w1=output(1);
     w2=output(2);
     w0=output(3);
    
 end
  if rem(epochs,10)==0 
      percent=percentCorrect( w1,w2,w0,rem80arr);
      trainerror(end+1)=100-percent;
  end
end
trainerrorarr(end+1,:)=trainerror;
end
meanarr=[];
standev=[];
for i=1:9
   meanarr(end+1)=mean(trainerrorarr(:,i));
   standev(end+1)=std(trainerrorarr(:,i));
end

plot(1:9,meanarr,'LineWidth',2)
hold;
errorbar(meanarr,standev,'x','LineWidth',2);
title('Mean&StandDev');
xlabel('trail number');
ylabel ('training error');

%{
%code to calculate metrics
metricTrain=quality(w1,w2,w0,rem80arr);
disp(metricTrain);
metricTest=quality(w1,w2,w0,rand20arr);
disp(metricTest);

%code to plot training error
plot(0:10:200,trainerror,'LineWidth',2);
title('Training Error:9');
xlabel('Epoch Numbers');
ylabel('Training Error');
axis([1 200 0 100])

%}













