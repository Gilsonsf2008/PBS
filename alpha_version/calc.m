function [RMSE_LS, RMSE_WLS, RMSE_GTRS, RMSE_SOCP, RMSE_ADMM, RMSE_SDP, RMSE_EKF, RMSE_RGTRS] = calc(l, w, h, n, sigma, mc, mcounter,d,et)
%
%   Calcule Types
%
RMSE = [ ];                       % Inicialization Variables
y_cap= zeros(size(d,1) + 1, 1);
RMSE_LS = [ ];
RMSE_WLS = [ ];
RMSE_GTRS = [ ];
RMSE_SOCP = [ ];
RMSE_ADMM = [ ];
RMSE_SDP = [ ];
RMSE_EKF = [ ];
RMSE_RGTRS = [ ];
%
tplot = (sigma/10):(sigma/10):sigma;
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
    [RMSE_LS] = calc_LS(l, w, n, sigma, mc);    
    plot(tplot,RMSE_LS, 'b-o');
    title('RMSE (m) for N = 15, B = 50 (m), and MC = 1000');
    xlabel('SIGMA');
    ylabel('RMSE(m)');
    axis([0.02 0.2 0 9]);
    grid;
    legend('LS');
%
  elseif mcounter == 3                % Calc WLS Estimator
%
    [RMSE_WLS] = calc_WLS(l, w, n, sigma, mc);
    plot(tplot,RMSE_WLS, 'r-*');
    title('RMSE (m) for N = 15, B = 50 (m), and MC = 1000');
    xlabel('SIGMA');
    ylabel('RMSE(m)');
    axis([0.02 0.2 0 9]);
    grid;
    legend('WLS');
%
  elseif mcounter == 4                  % calc GTRS Estimator
%
    [RMSE_GTRS] = calc_GTRS(l, w, n, sigma, mc);
    plot(tplot,RMSE_GTRS, 'm-d');
    title('RMSE (m) for N = 15, B = 50 (m), and MC = 1000');
    xlabel('SIGMA');
    ylabel('RMSE(m)');
    axis([0.02 0.2 0 9]);
    grid;
    legend('GTRS');
%
  elseif mcounter == 5                  % calc SCOP Estimator
%
    [RMSE_ADMM] = calc_ADMM(l, n, sigma, mc);
    plot(tplot,RMSE_ADMM, 'c-d');
    title('RMSE (m)for N = 15, B = 25 (m), and MC = 10.000');
    xlabel('SIGMA');
    ylabel('RMSE(m)');
    axis([0.02 0.2 0 4]);
    grid;
    legend('ADMM');
%
  elseif mcounter == 6                  % calc ADMM Estimator
%
    [RMSE_SOCP] = calc_SOCP(l, w, n, sigma, mc);
    plot(tplot,RMSE_SOCP, 'b-d');
    title('RMSE (m)for N = 15, B = 50 (m), and MC = 300');
    xlabel('SIGMA');
    ylabel('RMSE(m)');
    axis([0.02 0.2 0 4]);
    grid;
    legend('SOCP');
%
  elseif mcounter == 7                  % calc SDP Estimator
%
    [RMSE_SDP] = calc_SDP(l, w, n, sigma, mc);
    plot(tplot,RMSE_SDP, 'b-d');
    title('RMSE (m)for N = 15, B = 50 (m), and MC = 500');
    xlabel('SIGMA');
    ylabel('RMSE(m)');
    axis([0.02 0.2 0 5]);
    grid;
    legend('SDP');
%
  elseif mcounter == 8                  % calc EKF Estimator
%
   [RMSE_EKF, RMSE_WLS, ARMSE_EKF, ARMSE_WLS, RMSE_EKF_t, RMSE_WLS_t , x, a_i, theta, T] = calc_EKF(sigma, mc);
   ttplot = 0:1:T;
   plot(theta(1,:), theta(2,:), 'r-');
   title('The considered tracking scenario N = 8 and B = 30 (m)');
   xlabel('x(m)');
   ylabel('y(m)');
   axis([0 30 0 30]);
   grid;
   hold on;
   plot(x(1), x(2), 'g*', a_i(1,:), a_i(2,:), 'bs', 'linewidth', 2);
   hold off;
   %
   figure;
   plot(tplot,ARMSE_WLS, 'r-*',tplot,ARMSE_EKF, 'b-o');
   title('RMSE(m) vs. t(s) for N = 8, ?(t) = 0.2 (m), B = 30 (m), and MC = 100');
   xlabel('SIGMA');
   ylabel('RMSE(m)');
   axis([0.02 0.2 0 4]);
   grid;
   hold on;
   plot(tplot,RMSE_WLS, 'y-s',tplot,RMSE_EKF, 'm-d');
   legend('AWLS','AEKF', 'WLS', 'EKF');
   hold off;
   %
   figure;
   plot(ttplot, RMSE_WLS_t, 'r-*', ttplot, RMSE_EKF_t, 'b-o');
   title('RMSEt(m) vs. t(s) for N = 8, ?(t) = 0.2(m), B = 30(m), and MC = 500');
   xlabel('t(s)');
   ylabel('RMSEt(m)');
   axis([0 160 0 15]);
   grid;
   legend('WLS','EKF');
   %
  elseif mcounter == 9                  % calc RGTRS Estimator
%
  [RMSE_RGTRS, di, x, a_i, x_cap] = calc_RGTRS(l, w, n, sigma, mc);
%
  else mcounter == 10                  % calc LS, WLS, GTRS, SCOP, ADDM, EKF, RGTRS Estimator
%
  [RMSE_LS] = calc_LS(l, w, n, sigma, mc);
  [RMSE_WLS] = calc_WLS(l, w, n, sigma, mc);
  [RMSE_GTRS] = calc_GTRS(l, w, n, sigma, mc);
  [RMSE_ADMM] = calc_ADMM(l, w, n, sigma, mc);
  [RMSE_SOCP] = calc_SOCP(l, w, n, sigma, mc);
  [RMSE_SDP] = calc_SDP(l, w, n, sigma, mc);
  %[RMSE_EKF] = calc_EKF(sigma, mc);
  %[RMSE_RGTRS] = calc_RGTRS(l, w, n, sigma, mc);
  plot(tplot,RMSE_LS, 'b-o', tplot, RMSE_WLS, 'r-s', tplot,RMSE_GTRS, 'm-*', tplot, RMSE_ADMM, 'y-d', tplot, RMSE_SOCP, 'k-+', tplot, RMSE_SDP, 'c-x');
  title('RMSE (m) for N = 15, B = 50 (m), and MC = 300');
  xlabel('SIGMA');
  ylabel('RMSE(m)');
  axis([0.02 0.2 0 6]);
  grid;
  legend('LS', 'WLS', 'GTRS', 'ADMM', 'SOCP', 'SDP');
  end
end
