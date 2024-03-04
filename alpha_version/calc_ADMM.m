function [RMSE_ADMM] = calc_ADMM(l, w, n, sigma, mc)
%
% All Position & indepent values%
%
B = l/2;
if mc <= 1000
  mc = mc;
else
  mc = 10000;
end
%
RMSE_ADMM = [ ];
%
%      dependent values
%
ro = 2.001;         % Penalty therm
eps = 0.001;        % Tolerance maximum
Tmax = 10000;        % Maximum Interaction
%
for sigma = (sigma/10):(sigma/10):sigma
   %
   rmse_i = 0;
   c = 1;
   while c <= mc
    %                               position user and nodes
    x = rand(2,1) * (2 * B) - B;        
    a_i = rand(2,n) * (2 * B) - B;
    %                            distance into user andr nodes
    [di] = di_calc(x, a_i, n, sigma);       
    %
    %                       Initialization 'cap' values
    %
    x_cap = rand(2,1)*(2*B)- B;             
    u_cap = rand(2,n)*(2*B/5)- B/5;
    v_cap = rand(2,n)*(2*B/5)- B/5;
    lambda_cap = rand(2,n) * (2* B/5)- B/5;
    %
    t = 1;
    while t < Tmax
        x_pred = x_cap;                  % First estimate Position
        %
        x_cap = (1/n) * sum(a_i + v_cap,2);  % Position Predictive
        for i= 1:1:n
            beta = ((ro * di(i) * v_cap(:,i)) - (di(i) * lambda_cap(:,i)))/(ro * di(i).^2);
            u_cap(:, i) = beta / max(1,norm(beta));
            v_cap(:,i) = (x_cap - a_i(:,i) + lambda_cap(:,i) + (ro * di(i) * u_cap(:,i))) / ro;
            lambda_cap(:,i) = lambda_cap(:,i) + ro *(di(i) * u_cap(:,i) - v_cap(:,i));
            if norm(x_cap - x_pred) <= eps
                break;
            end
        end
        t = t + 1;
    end
    rmse_i = rmse_i + norm(x - x_cap)^2;
    c = c + 1;
   end
   RMSE_ADMM = [RMSE_ADMM, sqrt(rmse_i/mc)];
end
%
end