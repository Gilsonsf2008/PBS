function phi = phi_function(lambda_aux, A, D, b, f)
%
y = (A' * A + lambda_aux * D + 1e-6 * eye(size(D,1))) \ (A' * b - lambda_aux * f);
phi = y' * D * y + 2 * f' * y;
%
end