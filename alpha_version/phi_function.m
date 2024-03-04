function phi = phi_function(lambda, A, D, b, f)
%
y = (A' * A + lambda * D + 1e-6 * eye(size(D,1))) \ (A' * b - lambda * f);
phi = y' * D * y + 2 * f' * y;
end