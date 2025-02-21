% each column represents a single input
input=[0.2     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0;
      0     0.2    0     0     0     0     0     0     0     0     0     0     0     0     0     0;
     0     0     0.2     0     0     0     0     0     0     0     0     0     0     0     0     0;
     0     0     0     0.2    0     0     0     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0.2    0     0     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0.2    0     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0.2     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0.2     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0.2     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0     0.2     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0     0     0.2     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0     0     0     0.2     0     0     0     0;
     0     0     0     0     0     0     0     0     0     0     0     0     0.2    0     0     0;
     0     0     0     0     0     0     0     0     0     0     0     0     0     0.2    0     0;
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0.2     0;
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0.2; 
     1     1     1     1     1     1     0     0     0     0     1     0     0     0     0     0;
     0     0     0     0     0     0     1     1     1     1     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     1;
     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1;
     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1;
     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1;
     0     0     0     0     0     0     0     0     0     1     0     0     1     1     1     0;
     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0;
     0     0     0     0     1     1     1     1     0     1     1     1     1     0     0     0;
     0     0     0     0     0     0     1     1     1     1     0     1     1     1     1     0;
     1     0     0     1     1     1     1     0     0     0     0     0     0     0     0     0;
     0     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0];

 %{
 %normalizing to unit vector
 for i=1:16
     input(:,i)=input(:,i)/sqrt(input(:,i)'*input(:,i));
 end
 %}

     
 %each row represents weights for a output neuron
 weights=rand(100,29)/100;
 weightdeltas=zeros(100,29);
 output=zeros(100,1);
 rate=0;
 sigma=0;

 for i=1:2500
     if i<2001 % 1:2000 is for self organizing phase
     rate=0.1*exp(-i/1000);
     sigma=5*exp(-i/1243);
     else  % 2001:2500 is for convergence phase.
     rate=0.01;  
     end
     for k=1:16
         j=randi([1 16],1,1);
         temp=[];
         for s=1:100
             temp(end+1)=sqrt(sum((input(:,j)' -weights(s,:)) .^ 2));
         end
        [~,min1]=min(temp);
        weightdeltas=delta(min1,input(:,j),weights,sigma,rate);
        weights=weights+weightdeltas;
     end
 end

%code to print results
keySet =   [1:16];
valueSet = {'dove','hen','duck','goose','owl','hawk','eagle','fox',...
'dog','wolf','cat','tiger','lion','horse','zebra','cow'};
mapObj = containers.Map(keySet,valueSet);
 aa={};
 for i=1:10
 for j=1:10
 aa{i,j}='';
 end
 end
 highval=zeros(100,1);
 highpos=zeros(100,1);
 for i=1:16
     d=zeros(29,1);
     d(i)=0.2;
     q=weights*d;
     [~,m]=max(q);
     cc=coordinates(m);
     aa{cc(1),cc(2)}=mapObj(i);
     for j=1:100
     if(q(j)>highval(j))
       highval(j)=q(j);
       highpos(j)=i;
     end
    end
 end
 disp(aa);
 disp ('----------------------');
 aa={};
 for i=1:10
 for j=1:10
 aa{i,j}='';
 end
 end
 for i=1:100
 cc=coordinates(i);
 aa{cc(1),cc(2)}=mapObj(highpos(i));
 end
disp(aa);
 
 
 
 
 
 
 
 
 
 
 
 
 