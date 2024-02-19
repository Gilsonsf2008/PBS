function [RMSE_LS, RMSE_WLS, RMSE_GTRS, RMSE_SOCP, RMSE_SDP, RMSE_EKF] = calc(l, w, n, sigma, mc, mcounter)
%
%   Calcule Types
%
%di= zeros(2,n);
RMSE = [ ];                       % Inicialization Variables
y_cap= zeros(3, 1);
RMSE_LS = [ ];
RMSE_WLS = [ ];
RMSE_GTRS = [ ];
RMSE_SOCP = [ ];
RMSE_SDP = [ ];
RMSE_EKF = [ ];
%
  if mcounter == 1             % Calc Random Position x & a_is
%
   [x, a_i] = position(l, w, n);
   [di] = di_calc(x, a_i, n, sigma);
%
 plot(x(1), x(2), 'b*', a_i(1,:), a_i(2,:), 'ro', 'linewidth', 2);
 title('Position the x & a_is');
 grid;
 axis([0 l 0 w]);
 xlabel('Leight');
 ylabel('Width');
%
  elseif mcounter == 2                % Calc LS Estimator
%
  [RMSE_LS, di, x, a_i, x_cap] = calc_LS(l, w, n, sigma, mc);
%
  elseif mcounter == 3                % Calc WLS Estimator
%
  [RMSE_WLS, di, x, a_i, x_cap] = calc_WLS(l, w, n, sigma, mc);
%
  elseif mcounter == 4                  % calc GTRS Estimator
%
  [RMSE_GTRS, di, x, a_i, x_cap] = calc_GTRS(l, w, n, sigma, mc);
%
  elseif mcounter == 5                  % calc SCOP Estimator
%
  [RMSE_SOCP] = calc_SOCP(l, w, n, sigma, mc);
%
  elseif mcounter == 6                  % calc SDP Estimator
%
  [RMSE_SDP] = calc_SDP(l, w, n, sigma, mc);
%
  elseif mcounter == 7                  % calc EKF Estimator
%
  [RMSE_EKF, di, x, a_i, x_cap] = calc_EKF(l, w, n, sigma, mc);
%
  else mcounter == 8                  % calc LS, WLS, GTRS, SCOP, ADDM, EKF Estimator
%
  [RMSE_LS] = calc_LS(l, w, n, sigma, mc);
  hold on;
  [RMSE_WLS] = calc_WLS(l, w, n, sigma, mc);
  [RMSE_GTRS] = calc_GTRS(l, w, n, sigma, mc);
  [RMSE_SOCP] = calc_SOCP(l, w, n, sigma, mc);
  [RMSE_SDP] = calc_SDP(l, w, n, sigma, mc);
  %[RMSE_EKF] = calc_EKF(l, w, n, sigma, mc);
  %[RMSE_RGTRS] = calc_RGTRS(l, w, n, sigma, mc);
  hold off;
  end
end
