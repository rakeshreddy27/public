
% Simple KNN

rand20arr=importdata('testdata8.xls');%test data
rem80arr=importdata('traindata8.xls');% train data

matrix1=rand20arr; % matrix to test
matrix2=rem80arr; % matrix with initial information
resultmat=[];
for i=1:max(size(matrix1))
    distmat=[];
    for j=1:max(size(matrix2))
      distmat(end+1,:)=[ sqrt((matrix1(i,1)-matrix2(j,1))^2+(matrix1(i,2)-matrix2(j,2))^2 ),matrix2(j,3)];
      distmat=sortrows(distmat);
    end
    
    count0=0;
    count1=0;
   for c=1:17
      if(distmat(c,2)==0)
          count0=count0+1;
      else
          count1=count1+1;
      end
   end
  per0=floor(100*count0/c);
  per1=100-per0;
  majorper=max(per0,per1);
  
  while majorper<60 && c<=31
     
      c=c+1;
      if(distmat(c,2)==0)
          count0=count0+1;
      else
          count1=count1+1;
      
      end 
            
       per0=floor(100*count0/c);
       per1=100-per0;
       majorper=max(per0,per1);
    
  end
  
  
  if  per0>per1
      resultmat(i)=0;
  else
      resultmat(i)=1;
  end
end


q00=0;  %true negatives
q11=0;  %true positives
q01=0;  %false positives
q10=0;  %false negatives


for i=1:max(size(resultmat))
    
    disp(i);
   if(matrix1(i,3)==1 && resultmat(i)==0)
       q10=q10+1;
   end
   
   if(matrix1(i,3)==0 && resultmat(i)==1)
       q01=q01+1;
   end
   
   if(matrix1(i,3)==1 && resultmat(i)==1)
       q11=q11+1;
   end
   
   if(matrix1(i,3)==0 && resultmat(i)==0)
       q00=q00+1;
   end
    
end

sensitivity=q11/(q11+q10);
specificity=q00/(q00+q01);
ppv=q11/(q11+q01);
npv=q00/(q00+q10);

y = [sensitivity,specificity,ppv,npv];
disp(y);


% to draw a boundary
%{
minmax=importdata('minmax.xls');
xax=minmax(2):0.05:minmax(1);
yax=minmax(4):0.05:minmax(3);

part0=[];
part1=[];

for x=1:max(size(xax(1,:)))
    for y=1:max(size(yax(1,:)))
    
    distmat=[];
    for j=1:240
      distmat(end+1,:)=[ sqrt((xax(x)-rem80arr(j,1))^2+(yax(y)-rem80arr(j,2))^2 ),rem80arr(j,3)];
      distmat=sortrows(distmat);
    end
    
    count0=0;
    count1=0;
   for c=1:15
      if(distmat(c,2)==0)
          count0=count0+1;
      else
          count1=count1+1;
      end
   end
  per0=floor(100*count0/20);
  per1=100-per0;
  majorper=max(per0,per1);
  
  while majorper<60 && c<=31
     
      c=c+1;
      if(distmat(c,2)==0)
          count0=count0+1;
      else
          count1=count1+1;
          per0=floor(100*count0/20);
          per1=100-per0;
          majorper=max(per0,per1);
      end 
  end
  
  
  if  per0>per1
       part0(end+1,:)=[xax(x),yax(y)];
  else
       part1(end+1,:)=[xax(x),yax(y)];
  end
    end
end

scatter(part1(:,1),part1(:,2));
title('Boundry Diagram');
hold;
scatter(part0(:,1),part0(:,2)); 

%}

