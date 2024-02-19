function [di] = di_calc(x, a_i, n, sigma)
%
  di = sqrt((x(1)-a_i(1,:)).^2 + (x(2)-a_i(2,:)).^2)+sqrt((x(1)-a_i(1,:)).^2 + (x(2)-a_i(2,:)).^2)*sigma.*randn(1,n);
%
end
