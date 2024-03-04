function [x, a_i] = position(l, w, n)
%
% Calculo da posicao do usuario
%
x(1,1) = l*rand(1);
x(2,1) = w*rand(1);
%
% Calculo da posicao dos Nodes
  for j=1:n
    a_i(1,j) = l*rand(1);
    a_i(2,j) = w*rand(1);
  end
end