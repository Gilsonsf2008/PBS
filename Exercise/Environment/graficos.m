function graficos(user, node, mn, l, w, h)
%
% Graphics
%
close all
if mn == 1
  plot3(user(1), user(2), user(3), '*b', 'linewidth', 3, node(:,1), node(:,2), node(:,3), '@r', 'linewidth', 3);
  title('Position the User & Nodes');
  grid;
  axis([0 h], [0 w], [0 l]);
  xlabel('Leight');
  ylabel('Width');
  zlabel('Height');
elseif mn ==2
  
%
end