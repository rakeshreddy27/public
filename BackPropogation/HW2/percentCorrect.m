function percent = percentCorrect( w1,w2,w0,array)
% function to calculate the percentage of correct outputs
 count=0;
for i=1:max(size(array))
ws=w1*array(i,1)+w2*array(i,2)+w0*1;
if ws>=0
    if array(i,3)==1
        count=count+1;
    end
else
    if array(i,3)==0
        count=count+1;
    end     
end
end
percent=(count/i)*100;

end

