function percent = percentError(obtained,original)
% function to calculate the percentage of error outputs
count=0;
for i=1:max(size(obtained))
if obtained(i)~=original(i)
    count=count+1;
end
end
percent=(count/i)*100;
end