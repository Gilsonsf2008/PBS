function [user, node] = position(l, w, h, n)
%
% Calculo da posição do usuário
%
user(1,1)= rand(1)*l;
user(1,2)= rand(1)*w;
user(1,3)= rand(1)*h;
%
% Calculo da posição dos Nodes
%
for lin = 1:1:n
  node(lin,1)= rand(1)*l;
  node(lin,2)= rand(1)*w;
  node(lin,3)= rand(1)*h;
  lin = lin + 1;
endfor
end