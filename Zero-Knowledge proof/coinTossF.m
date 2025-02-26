% coin toss frequentist, binomial two pronged test (on both sides)

n = 1000;        % Total number of coin tosses
p0 = 0.5;        % Hypothesized probability of heads (fair coin)

% simulate coin tosses: toss > 0.5 is considered a head.
% uniformly distributed random numbers
tosses = rand(n, 1) > 0.5;
% generates an array of normal random numbers from the normal distribution
% with mean parameter mu and standard deviation parameter sigma.
% tosses = normrnd(1, 2, 1, n) > 0.5;
numHeads = sum(tosses);

fprintf('Number of Heads: %d\n', numHeads);

% Compute lower-tail probability: probability of obtaining numHeads or fewer heads.
p_lower = binocdf_custom(numHeads, n, p0);

% Compute upper-tail probability: probability of obtaining numHeads or more heads.
p_upper = 1 - binocdf_custom(numHeads - 1, n, p0);

% For a two-tailed test, double the smaller tail probability.
p_value = 2 * min(p_lower, p_upper);
if p_value > 1
    p_value = 1; % p-value cannot exceed 1
end

fprintf('Two-tailed p-value: %.4f\n', p_value);

% Plotting the Binomial Probability Mass Function (PMF)
x = 0:n;   % All possible outcomes (number of heads)
pmf = zeros(1, length(x));
for i = 1:length(x)
    pmf(i) = binopdf_custom(x(i), n, p0);
end

figure;
bar(x, pmf, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
hold on;
% mark the observed number of heads with a red circle.
plot(numHeads, binopdf_custom(numHeads, n, p0), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('Number of Heads');
ylabel('Probability Mass');
title(sprintf('Binomial PMF (n = %d, p = %.2f)', n, p0));
legend('Binomial PMF', 'Observed # of Heads');
hold off;

% Plotting the Binomial Cumulative Distribution Function
cdfVals = zeros(1, length(x));
for i = 1:length(x)
    cdfVals(i) = binocdf_custom(x(i), n, p0);
end

figure;
plot(x, cdfVals, 'b-', 'LineWidth', 2);
hold on;
% Mark the observed number of heads on the CDF.
plot(numHeads, binocdf_custom(numHeads, n, p0), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('Number of Heads');
ylabel('Cumulative Probability');
title('Binomial CDF');
legend('Binomial CDF', 'Observed # of Heads');
hold off;


function p = binopdf_custom(k, n, p0)
    % calculates the probability mass for exactly k heads in n tosses.
    % p0 is the probability of a head.
    c = nchoosek_custom(n, k);
    p = c * (p0^k) * ((1 - p0)^(n - k));
end

function cdf_val = binocdf_custom(x, n, p0)
    %  calculates the cumulative probability for obtaining up to x heads.
    cdf_val = 0;
    for i = 0:x
        cdf_val = cdf_val + binopdf_custom(i, n, p0);
    end
end

function c = nchoosek_custom(n, k)
    % nchoosek_custom computes the binomial coefficient "n choose k"
    if k > n
        c = 0;
        return;
    end
    c = 1;
    for i = 1:k
        c = c * (n - i + 1) / i;
    end
end
