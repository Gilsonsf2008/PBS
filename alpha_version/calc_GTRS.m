function [RMSE_GTRS] = calc_GTRS(l, w, n, sigma, mc)
%
%   Calcule Types GTRS Estimator
%
RMSE_GTRS= [ ];                       % Inicialization Variables
%
% Adiquirindo do usuário as variaveis mensuráveis
%
%[Imax, Tol, Intmax] = variaveis_GTRS;
%
for sigma = (sigma/10):(sigma/10):sigma
%
  rmse_i = 0;                              % Inicialization Counter
  c = 1; 
%
    while c <= mc
      [x, a_i] = position(l, w, n);
      [di] = di_calc(x, a_i, n, sigma);
%
%                                     Calc A & b
%
      for f = 1:1:n
        A1(f, :) = [-2*a_i(:, f)' 1];
        b1(f,1) = di(:, f).^2 - norm(a_i(:,f)).^2;
      end                              
%
      D = eye(3);
      D(3,3) = 0;
      f= [zeros(2,1); -1/2];
%                                      Calc W, y_aux & phi
%
      W = diag(sqrt((1./di)./(sum(1./di))));
      A = W * A1;
      b = W * b1;
%      
%                                     Calc  Bi Section
%
      eig_val = eig((A' * A)^(1/2) \ D / (A' * A)^(1/2));
      eig_max = max(eig_val);
      Imin = -1 / eig_max;
      Imax = 1e6;
      Tol = 1e-3;
      Intmax = 30;
%
      lambda = Bi_section(Imin, Imax, Tol, Intmax, A, D, b, f);
%
%                                     Calc RMSE_i
%
      y_aux = real((A' * A + lambda * D + 1e-6 * eye(size(A,2))) \ (A' * b - lambda * f));
      x_cap = y_aux(1:length(x), 1);
      rmse_i = rmse_i + norm(x - x_cap)^2;
      c = c + 1;
    end                    % End while
%
%                                     Calc RMSE
%
  RMSE_GTRS = [RMSE_GTRS, sqrt(rmse_i/mc)];
%
end                    % End For
%
end