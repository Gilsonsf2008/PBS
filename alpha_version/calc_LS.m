function [RMSE_LS] = calc_LS(l, w, n, sigma, mc)
%
%   Calcule LS Estimator
%
RMSE_LS = [ ];                      % Inicialization Variables
y_cap= zeros(3, 1);
x = zeros(2,1);
a_i = zeros(2,n);
%
for sigma = (sigma/10):(sigma/10):sigma           % For de Sigma x RMSE
%
  rmse_i= 0;
  c= 1;
%
  while c <= mc
   [x, a_i] = position(l, w, n);
   [di] = di_calc(x, a_i, n, sigma);
%
      for f = 1:1:n                    % For A & b
%
       A(f,:) = [-2 * (a_i(:,f))' 1];
       b(f,1) = di(:,f).^2 - norm(a_i(:,f)).^2;
%
      end                               % End For
%
   y_cap = (A' * A) \ (A' * b);
   x_cap = y_cap(1:2,1);
   rmse_i = rmse_i + norm((x - x_cap))^2;
   c = c + 1;
%
  end                               % End while

RMSE_LS= [RMSE_LS, sqrt(rmse_i/mc)];
end                                 % End the For S x R
%
end