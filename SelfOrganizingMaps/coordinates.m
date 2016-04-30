function c = coordinates( number )
%convert number to co-ordinates in 10x10 matrix
x=ceil(number/10);
y=rem(number,10);
if y==0
    y=10;
end
c=[x,y];
end

