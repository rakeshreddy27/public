function bayesianCoinTossBasic = bayesianCointTossBasic(iterations, tossesPerIteration, bins, typeOfDistributionOfRand)
% iterations how many simulated runs? Here I used 10000 total simulated runs.
ph = 0.5; % the coin is fair. ph is the probability of a head/tail
if strcmp(typeOfDistributionOfRand, 'normal')
    tosses = (normrnd(0.5, 0.2, iterations, tossesPerIteration) <= ph)*2 - 1;
else if strcmp(typeOfDistributionOfRand, 'uniform')
        tosses =  (rand(iterations, tossesPerIteration) <= ph)*2 - 1;
end

meanToss = mean(tosses, 1);
histfit(meanToss,bins);
end