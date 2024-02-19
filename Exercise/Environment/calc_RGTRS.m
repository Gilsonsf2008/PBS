% function [RMSE_RGTRS] = calc_RGTRS(l, w, n, sigma, mc)
%
n = 10;
B = 50;
l = 50;
w = 50;
k = 10;
Nm = 50;
sigma = 0.2;
PFA = 0.5;
mc = 500; % Monte Carlo
Delta = 15;

id_mal = unique(randi([1,n],1,randi([0,n/2],1,1)));
delta_i = zeros(1,n);

signum = randi([0,1],1,size(id_mal,2));
signum(find(signum==0)) = signum(find(signum==0))-1
delta_i(id_mal) = randi([-1,1]) * exprnd(Delta .* rand(1,size(id_mal,2)))

[x, a_i] = position(l, w, n);
[dik] = dik_calc(x, a_i, n, sigma, k, delta_i);

di = median(dik);
