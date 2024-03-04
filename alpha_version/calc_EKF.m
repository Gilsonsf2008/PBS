function [RMSE_EKF, RMSE_WLS, ARMSE_EKF, ARMSE_WLS, RMSE_EKF_t, RMSE_WLS_t , x, a_i, theta, T] = calc_EKF(sigma, mc)
%
n = 8;            % Numbers the Nodes
B = 30;           % Distance in meters
vt = 0.5;         % Target speed in m/s
T = 160;          % Time simulation in seconds
deltat = 1;        % Time sample in seconds
q = 0.05;          % Noise process state in m2/s3
if mc <= 1000
    mc = mc;
else
    mc = 1000;
end
%
% All Position & indepent values
%
x = [B/6; B/6];
a_i = [[0;0],[0;B], [B;0], [B;B], [0;B/2], [B/2;0], [B/2;B], [B;B/2]];
%
S = eye(2*size(x,1));
S(1,2*size(x,1)-1) = deltat;
S(2,2*size(x,1)) = deltat;
%
Qt = q * [[deltat^3/3, 0, deltat^2/2, 0];...
         [0, deltat^3/3, 0, deltat^2/2];...
         [deltat^2/2,0, deltat, 0];...
         [0, deltat^2/2, 0, deltat]];
%
theta = [x', 0.5, 0]';
%
for t=1:T - 20
  if t <= 20
    theta = [theta, S*theta(:,end)];
  elseif t > 20 && t <= 30
    theta = [theta, S*[theta(1:2, end);0; vt]];
  elseif t >30 && t <= 50
    theta = [theta, S*[theta(1:2, end); vt; 0]];
  elseif t >50 && t <= 80
    theta = [theta, S*[theta(1:2, end);0; vt]];
  elseif t > 80 && t <= 100
    theta = [theta, S*[theta(1:2, end);-vt; -vt]];
  elseif t > 100 && t <= 120
    theta = [theta, S*[theta(1:2, end);-vt; vt]];
  elseif t > 120 && t <= 140
    theta = [theta, S*[theta(1:2, end); 0; -vt]];
  end
  %
end
%
for alpha = pi/2:-pi/20:-pi/2
      theta = [theta, [5;10;0;0] + 5*[cos(alpha);sin(alpha);0;0]];
end
%
y_cap = zeros(3, 1);
I = eye(2*size(x,1));
Kt = [ ];
%
ARMSE_WLS = [ ];
ARMSE_EKF = [ ];
RMSE_EKF = [ ];
RMSE_WLS = [ ];
rmse_wls_t = zeros(1,T+1);
rmse_ekf_t = zeros(1,T+1);                % Inicialization Variables
%
for sigma = (sigma/10):(sigma/10):sigma
%                              % Inicialization Counter
RMSE_WLS_t = [ ];
RMSE_EKF_t = [ ];
wi_aux= 0;
wi= [ ];
Rt = diag(ones(n,1)*(sigma^2));
P = I;
c = 1;                         % Inicialization Counter
%                              % Monte carlo simulation
  while c <= mc                % Inicialization Counter
    swi_aux= 0;
    rmse_i = 0;
    rmse_i_ekf = 0;
    tt = 1;
    while tt <= T +1             % Position sequential simulation
%
      x = theta(1:2,tt);                   % Position one by one
      [di] = di_calc(x, a_i, n, sigma);    % distance by which position
%
%                                          % Begin WLS Evaluate
      for f = 1:1:n
        A(f,:) = [-2 * a_i(:, f)' 1];
        b(f,1) = di(:, f).^2 - norm(a_i(:, f)).^2;
        wi_aux = 1 .\ di(f);
        swi_aux = swi_aux + wi_aux;
      end
%
      for j = 1:1:n
       wi(j) = di(j) .\ swi_aux;
      end
      W = diag([sqrt(wi)]);
      y_cap = (A'* W'* W * A) \  (A' * W' * W * b);
      x_cap = y_cap(1:2);
      rmse_i = rmse_i + norm((x - x_cap))^2;
      rmse_wls_t(1,tt) = rmse_wls_t(1,tt) + norm((x - x_cap))^2;
%
%                                                 % Finish WLS Evaluate
%                                                 % Begin EKF Evaluation
%
      dt = di';
      if tt == 1
        theta_cap = [x_cap; 0; 0];     % First estimate Position
      else
        theta_cap_pred = S * theta_cap;
        for i = 1 : 1 : n
            J(i,:) = [(theta_cap_pred(1:2,:) - a_i(:,i))' / norm(theta_cap_pred(1:2,1) - a_i(:,i)), zeros(1,2)];
        end
        ht = sqrt((theta_cap_pred(1) - a_i(1,:)).^2 + (theta_cap_pred(2) - a_i(2,:)).^2)';
        P_pred = S * P * S' + Qt;
        Kt = (P_pred * J') / (J * P_pred * J' + Rt);
        theta_cap = theta_cap_pred + Kt * (dt - ht);
        P = (I - Kt * J) * P_pred;
      end
      x_cap_ekf = theta_cap(1:2);
      rmse_i_ekf = rmse_i_ekf + norm((x - x_cap_ekf))^2;
      rmse_ekf_t(1,tt) = rmse_ekf_t(1,tt) + norm((x - x_cap_ekf))^2;
      %
      tt = tt + 1;
    end
    %
    c = c  + 1;
  end                             % End while WLS & EKF
 %
  ARMSE_WLS = [ARMSE_WLS, sqrt(rmse_i/(T*mc))];
  ARMSE_EKF = [ARMSE_EKF, sqrt(rmse_i_ekf/(T*mc))];
  RMSE_WLS = [RMSE_WLS, sqrt(rmse_i/(mc))];
  RMSE_EKF = [RMSE_EKF, sqrt(rmse_i_ekf/(mc))];
 %
end                    % End For
%
RMSE_WLS_t = [RMSE_WLS_t, sqrt(rmse_wls_t/mc)];
RMSE_EKF_t = [RMSE_EKF_t, sqrt(rmse_ekf_t/mc)];
%
end