%function [RMSE_EKF, di, x, a_i, x_cap] = calc_EKF(l, w, n, sigma, mc)
%
clear all;
clc;
close all;
tic;
%
n = 8;            % Numbers the Nodes
B = 30;           % Distance in meters
vt = 0.5;         % Target speed in m/s
T = 160;          % Time simulation in seconds
deltat = 1;        % Time sample in seconds
q = 0.05;          % Noise process state in m2/s3
mc = 500;
%
% Monte carlo simulation
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
%plot(theta(1,:), theta(2,:), 'r-')

RMSE = [ ];
RMSE_WLS = [ ];
ARMSE = [ ];                     % Inicialization Variables
y_cap= zeros(3, 1);
%
for sigma = 0.02:0.02:0.2
%
c = 1;                              % Inicialization Counter
rmse_i= 0;
armse_i = 0;
swi_aux= 0;
wi_aux= 0;
wi= [ ];
I = eye(2*size(x,1));
P = I;
J = (zeros(4,n));
Kt = [ ];
tt = 1;
%
  while tt <= T + 1
    x = theta(1:2,tt);            % User (train) in all sequential position (161)
    while c <= mc
      [di] = di_calc(x, a_i, n, sigma);
%
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
    end                           % End while WLS   
%  
    Rt = di * q *randn;
    ht = norm(x - a_i);
    theta_cap = S * [x_cap; 0; 0];
    for z = 1:1:n
      J(1:2,z) = (x_cap - a_i(:,z))/(norm(x_cap - a_i(:,z)));
    end
    P = S * P * S' + Qt;
    Kt = P * J / (J' * P * J + Rt);
    theta_cap = theta_cap + Kt .* (di - ht);
    P = (I - Kt * J) * P;
    armse_i = armse_i + norm((x - theta_cap(1:2)))^2;
    tt = tt  + 1;    
  end                             % End while EKF      
 %
 RMSE_WLS = [RMSE_WLS, sqrt(rmse_i/mc)];
 ARMSE = [ARMSE, sqrt(armse_i/(T*mc))];
end                    % End For
%
figure;
graficos2D(RMSE);
hold on;
RMSE = ARMSE;
graficos2D(RMSE);
hold off;
toc;




%
%end
