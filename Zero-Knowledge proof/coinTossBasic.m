function coinTossBasic = coinTossBasic(iterations, phArray, ptArray)
for i=1:iterations % increasing by factor of 10
    n = 10^iterations ;   % number of tosses 
    H = 0 ;  % initialize Head count
    T = 0 ;  % initialize Tails count
    for j = 1:n     % loop of toss 
        if rand > 0.5  
            H = H+1;
        else           
            T = T+1;
        end
    end
phArray(1,i)=H/n
ptArray(1,i)=T/n;

end

% code to plot
% Create the x vector
x = 1:iterations;
% plot probablity of heads
plot(x, phArray);
% Add labels and a title
xlabel('iterations');
ylabel('probability of heads, tails');
title('coin toss');
hold;
% plot probabilit of tails
plot(x, ptArray);