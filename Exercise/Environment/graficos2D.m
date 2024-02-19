function graficos2D(RMSE)
%
% Graphics
%
  sigma = 0.02:0.02:0.2;
  plot(sigma, RMSE);
  title('Variacao de Sigma');
  grid;
  %axis([0 5], [0 0.2]);
  xlabel('Sigma');
  ylabel('RMSE (m)');
%
end