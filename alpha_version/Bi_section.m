function lambda = Bi_section(Imin, Imax, Tol, Intmax, A, D, b, f)
%
phi = 10^9;
inter = 1;
  while inter <= Intmax && abs(phi) > Tol
    lambda = (Imax + Imin) / 2;
    phi = phi_function(lambda, A, D, b,f);
    if phi > 0
      Imin = lambda;
    else
      Imax = lambda;
    end
    inter = inter + 1;
  end
end