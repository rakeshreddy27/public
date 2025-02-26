% Coin Toss Simulation to Determine the Effect of Sample Size (n)
% We test different values of n and check how the probability of heads converges to 0.5

clc; clear; close all;

% Define different values of n (number of coin flips)
n_values = [10, 50, 100, 500, 1000, 5000, 10000, 50000, 100000];

% Store probability estimates
estimated_probs = zeros(1, length(n_values));

% Loop through each value of n and simulate coin tosses
for i = 1:length(n_values)
    n = n_values(i);  % Number of flips
    tosses = rand(1, n) > 0.5;  % Generate random tosses (Heads = 1, Tails = 0)
    num_heads = sum(tosses);  % Count the number of heads
    estimated_probs(i) = num_heads / n;  % Calculate the probability of heads
    
    fprintf('For n = %d, estimated probability of heads = %.4f\n', n, estimated_probs(i));
end

% Plot results
figure;
semilogx(n_values, estimated_probs, 'bo-', 'MarkerSize', 8, 'LineWidth', 2); % Log scale for x-axis
hold on;
yline(0.5, 'r--', 'LineWidth', 2); % True probability (0.5) as a reference
xlabel('Number of Coin Flips (n)');
ylabel('Estimated Probability of Heads');
title('Effect of Sample Size (n) on Estimated Probability');
legend('Estimated Probability', 'True Probability (0.5)');
grid on;
