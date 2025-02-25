
% code to check if a function is truly random (in this case we are testing
% rand function of matlab, similar to a coin toss)
% X = rand returns a random scalar drawn from the uniform distribution in the interval (0,1).
% https://www.mathworks.com/help/matlab/ref/rand.html

iterations = 8;
ph = zeros(1, iterations);
pt = zeros(1, iterations);
coinTossBasic(iterations, ph, pt);
