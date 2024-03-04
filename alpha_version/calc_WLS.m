function [RMSE_WLS] = calc_WLS(l, w, n, sigma, mc)
%
%   Calcule Types WLS Estimator
%
RMSE_WLS = [ ];                      % Inicialization Variables
y_cap= zeros(3, 1);
%
for sigma = (sigma/10):(sigma/10):sigma
%
c = 1;                              % Inicialization Counter
rmse_i= 0;
swi_aux= 0;
wi_aux= 0;
wi= [ ];
%
  while c <= mc
    [x, a_i] = position(l, w, n);
    [di] = di_calc(x, a_i, n, sigma);

    for f = 1:1:n
      A(f,:) = [-2 * a_i(:, f)' 1];
      b(f,1) = di(:, f).^2 - norm(a_i(:, f)).^2;
      wi_aux = 1 .\ di(f);
      swi_aux = swi_aux + wi_aux;
    end            % End For

    for j = 1:1:n
     wi(j) = di(j) .\ swi_aux;
    end
    W = diag([sqrt(wi)]);
    y_cap = (A'* W'* W * A) \  (A' * W' * W * b);
    x_cap = y_cap(1:2);
    rmse_i = rmse_i + norm((x - x_cap))^2;
    c = c + 1;
  end                    % End while

RMSE_WLS = [RMSE_WLS, sqrt(rmse_i/mc)];
end                    % End For
%
end