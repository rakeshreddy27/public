% Bayesian Coin Toss Analysis 

% Define experiment parameters
n = 1000;          % Total number of coin tosses
p_true = 0.52;     % True probability of heads
tosses = rand(n, 1) < p_true;  % Simulate coin tosses (1 = Head, 0 = Tail)
numHeads = sum(tosses);   % Count number of heads
numTails = n - numHeads;  % Count number of tails

fprintf('Number of Heads: %d\n', numHeads);
fprintf('Number of Tails: %d\n', numTails);

% Define prior parameters (Uniform prior: Beta(1,1))
alpha_prior = 1;
beta_prior = 1;

% Compute posterior parameters (Bayesian update)
alpha_post = alpha_prior + numHeads;
beta_post = beta_prior + numTails;

% Define range of probability values for plotting
p_values = linspace(0, 1, 1000);  

% Compute the Prior Distribution (Beta PDF)
% betapdf can be also implemented, instead of using the inbuilt function
prior_pdf = betapdf(p_values, alpha_prior, beta_prior);

% Compute the Posterior Distribution (Updated Beta PDF)
posterior_pdf = betapdf(p_values, alpha_post, beta_post);

% Plot Prior and Posterior Distributions
figure;
plot(p_values, prior_pdf, 'b--', 'LineWidth', 2); hold on;  % Prior (blue dashed)
plot(p_values, posterior_pdf, 'r-', 'LineWidth', 2);  % Posterior (red solid)
xlabel('Probability of Heads (p)');
ylabel('Density');
title('Bayesian Update: Prior vs Posterior');
legend('Prior (Beta(1,1))', sprintf('Posterior (Beta(%d,%d))', alpha_post, beta_post));
grid on;
hold off;
