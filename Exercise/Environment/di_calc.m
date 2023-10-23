function [di, user, node] = di_calc(l, w, h, n, sig, mc)
%
%   graphic Models
%
if mc == 1;
  while (c <= mc)
  [user, node] = position(l, w, h, n);
  di = sqrt( (user(1) - node(n, 1)).^ 2 + (user(2) - node(n, 2)).^ 2 + (user(3) - node(n, 3)).^ 2) + ((sqrt( (user(1) - node(n, 1)).^ 2 + (user(2) - node(n, 2)).^ 2 + (user(3) - node(n, 3)).^ 2)) * sig * randn);
   c = c + 1;
 end
 %