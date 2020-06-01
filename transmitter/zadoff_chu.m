function x = zadoff_chu(u, q, N)
    n = (0:N-1);
    x = exp(-1j*pi*u*n.*(n+mod(N,2)+2*q)/N).';
end