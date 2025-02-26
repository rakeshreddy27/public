function gamma_val = gamma_custom(z)
    if z <= 0
        error('Gamma function is not defined for z <= 0');
    end
    if z > 1
        % Stirling's approximation for large values of z
        gamma_val = sqrt(2 * pi * z) * (z / exp(1))^z;
    else
        % Use recursive relation for Gamma function (for values <= 1)
        gamma_val = 1 / z * gamma_custom(z + 1);
    end
end