function [RMSE_SOCP, di, x, a_i] = calc_SOCP(l, w, n, sigma, mc)
%
%   Calcule Types SCOP Estimator
%
RMSE = [ ];
RMSE_SOCP = [ ];                       % Inicialization Variables
%
for sigma = 0.02:0.02:0.2
%
  c = 1;                              % Inicialization Counter
  rmse_i = 0; 
%
  while c <= mc
    [x, a_i] = position(l, w, n);
    [di] = di_calc(x, a_i, n, sigma);
%
%                                     Calc SCOP
%
    cvx_begin quiet
%      
      variable x_cap(2)
      variable y
      variable e(n)
 %
      minimize sum(e)
 %     
      subject to
        norm([2 * x_cap; y - 1]) <= y + 1;
        for j = 1:n
          norm([2*(y - 2*a_i(:,j)'*x_cap + norm(a_i(:,j))^2 - di(:,j)^2); 4*(y - 2*a_i(:,j)'*x_cap + norm(a_i(:,j))^2) - e(j)]) <= 4 * (y - 2*a_i(:,j)'* x_cap + norm(a_i(:,j))^2) + e(j);
          e(j) >= 0;
        end
 %  
     cvx_end
       rmse_i = rmse_i + norm(x - x_cap)^2;
       c = c + 1;
  end
%
%                                     Calc RMSE
%
  RMSE_SOCP = [RMSE_SOCP, sqrt(rmse_i/mc)];
  RMSE = RMSE_SOCP;
%
end                    % End For
%
graficos2D(RMSE);
end
