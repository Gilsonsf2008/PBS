function [dik] = dik_calc(x, a_i, n, sigma, k, delta_i)
%
  dik = sqrt((x(1)-a_i(1,:)).^2 + (x(2)-a_i(2,:)).^2)+sqrt((x(1)-a_i(1,:)).^2 + (x(2)-a_i(2,:)).^2) * sigma .* randn(n,k) + delta_i;
%
end
