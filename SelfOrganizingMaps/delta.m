function delta = delta(min,input,weights,sigma,rate)
%Calculates delta
delta=zeros(size(weights));
for i=1:100
   dist=sum((coordinates(i)-coordinates(min)).^2);
   temp2=rate*exp(-dist/(2*sigma^2)); 
   delta(i,:)= (input'-weights(i,:))*temp2;
end
end

