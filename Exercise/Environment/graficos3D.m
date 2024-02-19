function graficos3D(x, a_i, mp, l, w, h, s)
%
% Graphics
%
close all
%
if mp == 1
   plot3(x(1), x(2), x(3), '*b', 'linewidth', 3, a_i(:,1), a_i(:,2), a_i(:,3), '@r', 'linewidth', 3);
   title('Position the x & a_is');
   grid;
   axis([0 l], [0 w], [0 l]);
   xlabel('Leight');
   ylabel('Width');
   zlabel('Height');
   figure;
%  elseif mp ==2
  sigma = 0:0.02:(10*s)
  plot(sigma, s);
  title('Variação de Sigma');
  grid;
  xlabel('Sigma');
  ylabel('Variação');
end
end
