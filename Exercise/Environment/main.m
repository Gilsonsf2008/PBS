%
clear;
close all;
clc;          % Inicializando todas as variaveis e Limpa a tela
%
tic;
begin;         % Open Screen
%
               % Inicitiation counters
mcounter = 0;
%
                % Initial Variable
%[l, w, n, sigma, mc] = variaveis;
l = 50;
w = 50;
n = 15;
sigma = 0.2;
mc = 1;
%
while (mcounter == 0)
  mcounter = menu('Escolha: ', 'Randon Position', 'LS', 'WLS', 'GTRS', 'SOCP', 'SDP', 'EKF','All');
  [RMSE_LS, RMSE_WLS, RMSE_GTRS, RMSE_SOCP, RMSE_SDP, RMSE_EKF] = calc(l, w, n, sigma, mc, mcounter);
end
toc;