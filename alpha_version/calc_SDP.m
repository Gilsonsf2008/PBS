function [RMSE_SDP] = calc_SDP(l, w, n, sigma, mc)
%
%   Calcule Types ADMM Estimator
%
close;
%
%                      % Inicialization Variables
%
l = l /2;
w = w / 2;
M = 25;
R = 7;
d0 = 1;
RMSE_SDP = [ ];
%
if mc <= 500
    mc = mc;
else
    mc = 500;
end
%
%                                   % Loop FOR
%
for sigma = (sigma/10): (sigma/10): sigma
%
c = 1;                              % Inicialization Counter
rmse_i = 0; 
%
  while c <= mc

  regular = 0;
    while regular == 0
      Pos = [l*rand(1,M+n);w*rand(1,M+n)];            % Random positions in 2D
      D = dist(Pos);                                  % Distances between all nodes (0s on the diagoal)
      D(1:1+size(D,1):end) = 1;                       % Forcing ones on the main diagonal so I cancheckif∥xi −sj∥≤d0
    %    
      if sum(sum(D < d0)) <= 0
        P = D <= R * ones(M+n,M+n);                  % Gives either 0 or 1
        P(M+1:M+n,M+1:M+n) = eye(n);                 % Not interested in anchor/anchor links
        [p,q,r,s] = dmperm(P);                       % Check if the graph is connected5:
      %       
        if size(r,2) - 1 == 1
          regular = 1;
          a_i = Pos(:,(M+1):(M+n));                 % True anchor locations x = Pos(:,1:M); % True target locations
          x = Pos(:,1:M);                           % True target locations
        end
      end
    end
    %
    dij = [ ];
    %
    for i = 1:M
      for j = 1:n
        if norm(x(:,i) - a_i(:,j)) <= R
          dij = [dij; [i, j, norm(x(:,i) - a_i(:,j)) + norm(x(:,i) - a_i(:,j))* sigma*randn]];
        end
      end
    end
    %
    dik = [ ];
    %
    for i = 1: M - 1
      for k = i + 1: M
        if norm(x(:,i) - x(:,k)) <= R
          dik = [dik; [i, k, norm(x(:,i) - x(:,k)) + norm(x(:,i) - x(:,k))* sigma*randn]];
        end
      end
    end
    %
    %                           Plot x & a_i
    %
    close all;
     plot(x(1,:), x(2,:), 'b*', a_i(1,:), a_i(2,:), 'ro', 'linewidth', 2)
        line([a_i(1,dij(:,2)), x(1,dij(:,1))],[a_i(2,dij(:,2)), x(2,dij(:,1))])
    line([x(1,dik(:,2)), x(1,dik(:,1))],[x(2,dik(:,2)), x(2,dik(:,1))])
    %
%                                     Calc SCOP
    %
    e = eye(M);
    I = eye(size(x,1));
    %
    cvx_begin quiet
    %      
      variable x_cap(size(x,1),M)
      variable Y(M,M)
      variable hij(length(dij)+length(dik), 1)
    %
      vx = [dij(:,3); dik(:,3)];
    %
      minimize sum((vx.^2 - hij).^2)
    %     
      subject to
        for tt = 1:length(dij)
          i = dij(tt, 1);
          j = dij(tt, 2);
          hij(tt, 1) == [a_i(:,j)', -e(:,i)'] * [I, x_cap;x_cap', Y] * [a_i(:,j); -e(:,i)];
        end
      %
        for tt2 = 1:length(dik)
          i = dik(tt2, 1);
          j = dik(tt2, 2);
          hij(tt2+length(dij), 1) == [zeros(1, size(x,1)) , (e(:,i) - e(:,j))'] * [I, x_cap ; x_cap', Y] * [zeros(size(x,1),1); e(:,i) - e(:,j)];
        end
      %
        [I x_cap; x_cap' Y] == semidefinite(M+size(x,1));
      %
      cvx_end
%
    rmse_i = rmse_i + norm(x(:) - x_cap(:))^2;
    c = c + 1;
  end
%
%                                     Calc RMSE
%
  RMSE_SDP = [RMSE_SDP, sqrt(rmse_i/(M*mc))];
%
end
%
end