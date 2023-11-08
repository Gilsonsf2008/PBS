%
clear all, clc;          % Inicializando todas as variaveis e Limpa a tela
%
begin;
%
[l, w, h, n, sig, mc] = variaveis;
%
mn= 0;
while (mn == 0)
  mn = menu('Escolha: ', 'Calc di', 'LS', 'WLS', 'RLS', 'TLS', 'All');
end
%
if mn == 1
  [di, user, node] = di_calc(l, w, h, n, sig, mc);
elseif mn == 2
  ls = lsestimator(l, w, h, n, sig);
elseif mn == 3
  wls = wlsestimator(l, w, h, n, sig);
elseif mn == 4
  rls = rlsestimator(l, w, h, n, sig);
elseif mn == 5
  tls = tlsestimator(l, w, h, n, sig);
else mn == 6
  all = allestimator(l, w, h, n, sig);
end
mn= 0;
while (mn==0)
  mn = menu('Choose graphics models: ', "Dot's User & Nodes");
end
%
if mn ==1
  graficos(user, node, mn, l, w, h);
end
%
  