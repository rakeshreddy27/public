%To define number of layers 
%and nodes in each layer
layerSizes=[2,5,1];
%LayerSizes size-1
learningRates=[0.9,0.9];
%LayerSizes size-1
momentums=[0.5,0.5];
%set number of epochs
epochs=200;

[~,jls]=size(layerSizes);
%create a cell of arrays for weights in x+1,y format 
% x+1 to accommodate the bias
for i=2:jls
    x=layerSizes(i-1);
    y=layerSizes(i);
    weightcell{i-1}=rand(x+1,y);
    prevdeltacell{i-1}=zeros(x+1,y);
    end




%code to test the network
input = [0 0 ;  1 0;  0 1; 1 1];
expected = [ 1; 0; 0;1];
for i=1:5000
    u=rem(i,4)+1;
    output=outputs(weightcell,input(u,:));
    c=delta(input(u,:),weightcell,output,expected(u,:),learningRates);
    for s=1:jls-1
     weightcell{s}=weightcell{s}-(c{s}+momentums(s)*prevdeltacell{s});
    end
    prevdeltacell=c;
end


    

paramtestarr=[];
paramtrainarr=[];
trainerrorarr=[];
for z=1:9
  %initializing weights and prevdeltacell for each iteration
    for i=2:jls
    x=layerSizes(i-1);
    y=layerSizes(i);
    weightcell{i-1}=rand(x+1,y);
    prevdeltacell{i-1}=zeros(x+1,y);
    end
    
filtest=strcat('testdata',int2str(z),'.xls');
filtrain=strcat('traindata',int2str(z),'.xls');
rand20arr=importdata(filtest);
rem80arr=importdata(filtrain);
trainerror=[];
for i=0:epochs
    % trainerror initially
    o=[];
     if i==0
       for j=1:240
       output=outputs(weightcell,rem80arr(j,1:2));
       o(j)=output{end};
       end
       trainerror(end+1)=percentError(rem80arr(:,3),round(o));
       continue
     end
    
     %updating weights in online fashion
     for k=1:240
     output=outputs(weightcell,rem80arr(k,1:2));
     del=delta(rem80arr(k,1:2),weightcell,output,rem80arr(k,3),learningRates);
     for s=1:jls-1
     weightcell{s}=weightcell{s}-(del{s}+momentums(s)*prevdeltacell{s});
     end
     prevdeltacell=del;
     end
     % trainerror for every 10 epochs
     o=[];
     if rem(i,10)==0
       for j=1:240
       output=outputs(weightcell,rem80arr(j,1:2));
       o(j)=output{end};
       end
       trainerror(end+1)=percentError(rem80arr(:,3),round(o));
     end
     
end

o=[];
for i=1:240
output=outputs(weightcell,rem80arr(i,1:2));
o(i)=output{end};
end
paramtrain=permetrics(rem80arr(:,3),round(o));

o=[];
for i=1:60
output=outputs(weightcell,rand20arr(i,1:2));
o(i)=output{end};
end
paramtest=permetrics(rand20arr(:,3),round(o));

paramtestarr(end+1,:)=paramtest;
paramtrainarr(end+1,:)=paramtrain;
trainerrorarr(end+1,:)=trainerror;


%Code to draw training error
figure('name',int2str(z));
plot(0:10:200,trainerror,'LineWidth',2);
title(strcat('Training Error',int2str(z)));
xlabel('Epoch Numbers');
ylabel('Training Error');
axis([1 200 0 50])




xv=1:4;
y=[];
for h=1:max(size(paramtest))
    y(end+1,1)=paramtrain(h);
    y(end,2)=paramtest(h);
end

% code to draw bar graphs
figure('name',int2str(z+1));
bar(xv,y);
title(strcat('Performance: ',int2str(z)));
name = {'Sensitivity', 'Specificity', 'PPV', 'NPV'};
set(gca,'XTickLabel', name);

end




%code to draw the mean and std of training error
meanarr=[];
standev=[];
for i=1:9
    meanarr(end+1)=mean(trainerrorarr(:,i));
    standev(end+1)=std(trainerrorarr(:,i));
end

figure('name','mean&std');
plot(1:9,meanarr,'LineWidth',2)
hold;
errorbar(meanarr,standev,'x','LineWidth',2);
title('Mean&StandDev');
xlabel('trail number');
ylabel ('training error');




%code to generate mean and std of performance metrics

paramMeanTrain=[];
paramStdTrain=[];
paramMeanTest=[];
paramStdTest=[];
for i=1:4
    paramMeanTrain(end+1)=mean(paramtrainarr(:,i));
    paramStdTrain(end+1)=std(paramtrainarr(:,i));
    
    paramMeanTest(end+1)=mean(paramtestarr(:,i));
    paramStdTest(end+1)=std(paramtestarr(:,i));
    
end


%code to draw the decision boundary
minmax=importdata('minmax.xls');
xax=minmax(2):0.1:minmax(1);
yax=minmax(4):0.1:minmax(3);
part0=[];
part1=[];
for x=1:max(size(xax(1,:)))
    for y=1:max(size(yax(1,:)))
        output=outputs(weightcell,[xax(x),yax(y)]);
        if round(output{end})==0
            part0(end+1,:)=[xax(x),yax(y)];
        else
            part1(end+1,:)=[xax(x),yax(y)];
        end
    end
end
figure('name','boundary');
scatter(part1(:,1),part1(:,2),40,'MarkerEdgeColor',[0.0 .75 .75],...
              'MarkerFaceColor',[0.0 .7 .7],...
              'LineWidth',1.5)

title('Boundry Diagram');
hold;
scatter(part0(:,1),part0(:,2),40,'MarkerEdgeColor',[0.0 .25 .25],...
              'MarkerFaceColor',[0.0 .3 .3],...
              'LineWidth',1.5)
%}

disp finished;
    %}