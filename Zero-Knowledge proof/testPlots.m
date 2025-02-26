% Not using this in code

% parameters of the Beta distribution
a = 2;  % Shape parameter alpha
b = 10;  % Shape parameter beta

% Define the range of values for the random variable x
x = 0:0.01:1;  % x values from 0 to 1 with a step of 0.01

% Compute the Beta function B(a, b)
beta = gamma_custom(a) * gamma_custom(b) / gamma_custom(a + b);

% Compute the Beta PDF manually for each value of x
y = (x.^(a - 1)) .* ((1 - x).^(b - 1)) / beta;

% Plot the Beta PDF
plot(x, y, 'LineWidth', 2);
title(['Beta Distribution PDF with a = ', num2str(a), ' and b = ', num2str(b)]);
xlabel('x');
ylabel('Probability Density');
grid on;


