% Parameters
alpha = 1; % Prior parameter alpha (Beta(1, 1) prior, uniform distribution)
beta = 1;  % Prior parameter beta
num_flips = 0; % Initialize number of flips
heads = 0; % Number of heads
tails = 0; % Number of tails
threshold = 0.05; % Stop threshold for the credible interval width
max_flips = 1000; % Max number of flips for stopping criteria

% Loop until stopping condition is met
while num_flips < max_flips
    % Simulate a coin flip (1 for heads, 0 for tails)
    flip = rand < 0.5; % Fair coin assumption (50% heads)
    
    % Update heads and tails counts
    if flip
        heads = heads + 1;
    else
        tails = tails + 1;
    end
    
    % Update posterior distribution (Beta distribution)
    posterior_alpha = alpha + heads;
    posterior_beta = beta + tails;
    
    % Calculate 95% credible interval for the coin's bias (probability of heads)
    credible_interval = betainv([0.025 0.975], posterior_alpha, posterior_beta);
    
    % Check if the credible interval is narrow enough around 0.5 (fair coin)
    interval_width = credible_interval(2) - credible_interval(1);
    
    % Stop if the interval is narrow enough around 0.5
    if interval_width < threshold && credible_interval(1) <= 0.5 && credible_interval(2) >= 0.5
        fprintf('Stopping after %d flips. Coin is likely fair.\n', num_flips);
        fprintf('Posterior credible interval: [%.3f, %.3f]\n', credible_interval(1), credible_interval(2));
        break;
    end
    
    num_flips = num_flips + 1; % Increment number of flips
end

% If the loop runs out of flips, print results
if num_flips == max_flips
    fprintf('Max flips reached. Final posterior credible interval: [%.3f, %.3f]\n', credible_interval(1), credible_interval(2));
end
