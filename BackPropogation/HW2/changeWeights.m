function output = changeWeights( w1,w2,w0,data,e)
% function to change the weights based on error

ws=w1*data(1,1)+w2*data(1,2)+w0*1;

yhat=0;
if ws>=0
    yhat=1;
end

w1=w1+e*(data(1,3)-yhat)*data(1,1);
w2=w2+e*(data(1,3)-yhat)*data(1,2);
w0=w0+e*(data(1,3)-yhat);

output=[w1,w2,w0];



end

