%
clear all;
close all;
clc;          % Inicializando todas as variaveis e Limpa a tela
%
tic;
%                Inicitiation counters
lan = 0;
d = 0;
et = 0;
mcounter = 0;
%                         % Choose language
while (lan == 0)
  lan = menu('Choose Language:','English', 'Portuguese', 'Spanish');
  if lan == 1
    begin;
  elseif lan == 2
    begin_pt;
  else lan == 3
    begin_esp;
  end
end
%
fprintf(' \n');
%
                % Initial Variable
%
while (mcounter == 0)
  mcounter = menu('Escolha: ', 'Randon Position', 'LS', 'WLS', 'GTRS', 'ADMM', 'SOCP', 'SDP', 'EKF', 'RGTRS', 'All');
end
%                          Choose Dimension
%
while (d == 0)
  d = menu('Chosse dimension:', '2 Dimension', '3 Dimension');
  end
%                          Choose Data Entry
%
while (et == 0)
  et = menu('Chooose data entry type:', 'Automatic', 'Manual');
  if et == 1
    l = 50;
    w = 50;
    h = 50;
    n = 15;
    sigma = 0.2;
    mc = 300;
    fprintf('Use in all Model\n');
    fprintf(' \n');
    if d == 1
      fprintf('Length = %s, Width = %s\n', l , w);
    else
      fprintf('Length = %d, Width = %d, Height = %d\n', l, w, h);
    end
    fprintf('Nodes = %d\n', n);
    fprintf('Sigma = %3.1f\n',sigma);
    fprintf('Monte Carlo simulation = %d\n', mc);
    fprintf(' \n');
    fprintf('Use only GTRS Model\n');
    fprintf(' \n');
    fprintf('Maximum Interval = 1e6\n');
    fprintf('Maximum Tolerance = 1e-3\n');
    fprintf(' \n');
    fprintf('Use only SDP Model\n');
    fprintf('Radius = 7\n');
    fprintf(' \n');
    fprintf('Use only RGTRS Model\n');
    fprintf(' \n');
    fprintf('Probability fail alarm = 0.5\n');
    fprintf('Numbers Attackers = 50\n');
    fprintf('Measurement samples = 10\n');
    %
  else
    [l, w, h, n, sigma, mc] = variaveis;
  end
end
[RMSE_LS, RMSE_WLS, RMSE_GTRS, RMSE_ADMM, RMSE_SOCP, RMSE_SDP, RMSE_EKF, RMSE_RGTRS] = calc(l, w, h, n, sigma, mc, mcounter,d,et);
%
toc;
