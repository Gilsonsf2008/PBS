% function [RMSE_RGTRS] = calc_RGTRS(l, w, n, sigma, mc)
clear all;
close all;
clc;
%                       Variables
n = 10;         % nodes
B = 50;         % dimension l and w
k = 10;         % smaple measurementsnodes
Nm = 50;        % number the attacks
sigma = 0.2;
PFA = 0.5;      % probability false alarm
Nd = 10;        % Monte Carlo 
Delta = 15;     % Variations Range
RMSE = [ ];
RMSE_RGTRS = [ ];
%
%                           Malicious Counters
cmalcount = zeros(1, 15 + 1);
fmalcount = zeros(1, 15 + 1);
ndmalcount = zeros(1, 15 + 1);
%                                       % Calc using GTRS Estimator
%
for Delta = 0:1:Delta
%
  rmse_i = 0;                              % Inicialization Counter
  rmse_i_gtrs = 0;
  dcoun = 1;
  nmalcount = 1;
  %cmal = 1;                                % Initialization malicious counter;
  c = 1;                                   % Inicialization Monte Carlo Counter;
  while c <= Nd
%
  [x, a_i] = position(B, B, n);
  sigma_cap_aux = [ ];
  cmal = 1;                              % Initialization malicious counter;
  %
      while cmal <= Nm
          %                     create malicius nodes
          if Delta == 0
              id_mal = zeros(n,1);                                % No malicious
          else
              %id_mal = unique(randi([1,n],1,randi([0,n/2],1,1))); % 50% malicius anchors
              id_mal = randi([0 1], n, 1);
              while sum(id_mal) > n/2
                  id_mal(randi(n,1)) = 0;
              end
          end
          %                         Signal & intensities to attackers
          %
          malicious = find(id_mal == 1);
          signum = randi(2,size(malicious,1),1) -1; 
          signum(~signum) = -1;
          %
          %                         Create every malicious with signum + / -
          delta_i = zeros(n,1);  
          delta_i(malicious) = exprnd(Delta * rand(size(malicious,1),1)) .* sigma;
          %
          %                         Distance calculation by any 'k'
          %
          [dik] = dik_calc(x, a_i, n, sigma, k, delta_i);
          for i = 1 : 1 : n
            while sum(dik(i,:) < 1) > 0
                k = find(dik(i,:) < 1);
                dik(i,k) = 1 + sigma * randn(1,size(k,2));
            end
            while sum(dik(i,:) < 1) > 0
                if K == 1
                    k = find(dik < 1);
                    dik(k) = norm(x - a_i(:,i)) + sigma * randn(1,size(k,2));
                else
                    k = find(dik(i,:) < 1);
                    dik(i,k) = norm(x - a_i(:,i)) + sigma * randn(1,size(k,2));
                end
            end
          end
          di = median(dik,2)';

    %                                     Calc RGTRS
    %
          A = zeros(2*n,size(x,1)+1);
          b1 = zeros(n,size(x,1)+1);
          for f = 1:n
            A1(f,:) = [2*(a_i(:, f))' -1];
            b1(f,1) = norm(a_i(:,f)).^2 - (di(1,f) + (Delta/2))^2;
          end  
          for f = 1:n
            A1(end + 1,:) = [2*(a_i(:, f))' -1];
            b1(end + 1,1) = norm(a_i(:,f)).^2 - (di(1,f) - Delta)^2;
          end  
          D = eye(size(x,1)+1);
          D(size(x,1)+1, size(x,1)+1) = 0;
          h = [zeros(size(x,1),1); -1/2];
    %
    %                                      Calc W, y_aux & phi
    %
          W = diag([sqrt((1./di)./(sum(1./di))),sqrt((1./di)./(sum(1./di)))]');
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
          lambda = Bi_section(Imin, Imax, Tol, Intmax, A, D, b, h);
   %
    %                                     Calc RMSE_i
    %
          y_aux = real((A' * A + lambda * D + 1e-6 * eye(size(A,2))) \ (A' * b - lambda * h));
          x_cap = y_aux(1:length(x), 1);
          rmse_i = rmse_i + norm(x - x_cap)^2;
    %
    %                                   Malicious Detection
    for i = 1: n
        delta_cap = sum(dik(:,i) - norm(x_cap - a_i(:,i)))/K;
        sigma_cap_aux = [sigma_cap_aux; sum((dik(:,i) - norm(x_cap - a_i(:,i)) - delta_cap).^2)];
    end
    sigma_cap = sqrt(sum(sigma_cap_aux) / (N * K - 1));
    %
    %                   Calc Thresshold & Malicious (Ho & H1 condition)
    for i = 1: n
      gamma = exp(0.5 * (qfuncinv(PFA/2))^2);
      thre = sqrt((2 * (sigma_hat^2) * ln(gamma))/K); 
      if abs(sigma_cap(i)) < thre                           % Ho - considering no Malicious 
         if delta_i(i) ~= 0                                 % Malicius not detected
            ndmalcount(Delta + 1) = ndmalcount(Delta + 1) + 1;
         end
      elseif abs(sigma_cap(i)) > threshold                  % H1 - consideing Malicious 
         if delta_i(i) ~= 0                                 % Malicious occured
            cmalcount = cmalcount + 1;
         else                                               % False maliciousAttack
            fmalcount = fmalcount + 1;
         end
      end
    end
            % Make sure all non detected attacks are counted
        if size(malicious,1) - (cmalcount + fmalcount) > 0
           ndmalcount(Delta + 1) = ndmalcount(Delta + 1) + size(malicious,1) - (cmalcount + fmalcount);
        end
            % Update counters
    cmalcount(Delta + 1) = cmalcount(Delta + 1) + correct_aux_counter;
    fmalcount(Delta + 1) = fmalcount(Delta + 1) + false_aux_counter;
    num_attacks_counter = num_attacks_counter + 1;
    end
        dcount = dcount + 1;
    end
    RMSE_GTRS = [RMSE_GTRS, sqrt(RMSE_i_GTRS/(Nd * Nm))];
    RMSE_R_GTRS = [RMSE_R_GTRS, sqrt(RMSE_i_R_GTRS/(Nd * Nm))];
end

% Plot RMSE
plot(0 : 1 : 15, RMSE_GTRS, 'k')
hold on
plot(0 : 1 : 15, RMSE_R_GTRS, 'r')
grid on

% Plot Attacks figure
f = figure;
hold on
for i = 1 : 1 : Delta
    index = i - 1;
    % Compute percentages
    total = correct_attacks_counter(1, i) + false_attacks_counter(1, i) + not_detected_attacks_counter(1, i);
    detection_rate = [(correct_attacks_counter(1, i) * 100) / total; (false_attacks_counter(1, i) * 100) / total; (not_detected_attacks_counter(1, i) * 100) / total];
    % Plot Attack Detection
    bh = bar(index,detection_rate,'stacked');
    % Set the bar colors
    set(bh, 'FaceColor', 'Flat')
    bh(1).CData = [0 0 1]; % Blue
    bh(2).CData = [1 0 0]; % Red
    bh(3).CData = [1 1 0]; % Yellow
    hold on
    grid on
end  
        
        
        
          cmal = cmal + 1;
      end
    c = c + 1;
  end
  %                                     Calc RRMSE_RGTRS
  %
  RMSE_RGTRS = [RMSE_RGTRS, sqrt(rmse_i/mc)];
end
%
tplot = 0:1:Delta
plot(tplot,RMSE_RGTRS);  
%
%end
