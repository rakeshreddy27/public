function bayesianCoinTossBasic = bayesianCointTossBasic(iterations, tossesPerIteration, bins, typeOfDistributionOfRand, mu, sigma)
% iterations how many simulated runs? Here I used 10000 total simulated runs.

p = 0.5; % the coin is fair. ph is the probability of a head/tail

% if the coin toss follows normal distribution, mean of each batch will be
% close to the mean
% adjusting mu, sigma below produces that tossess close to mean and within number of standard deviations.
if strcmp(typeOfDistributionOfRand, 'normal')
    tosses = (normrnd(mu, sigma, iterations, tossesPerIteration) <= p)*2 - 1;
end

%Rand follows uniform distribution, i.e all the values are equally likely
if strcmp(typeOfDistributionOfRand, 'uniform')
        tosses =  (rand(iterations, tossesPerIteration) <= p)*2 - 1;
end

meanToss = mean(tosses, 2);
histfit(meanToss,bins);
end
