function d = map2symbols(c, constellation_order, switch_graph)
  if isempty(c)
     d = []; 
  else
    % set parameters
    n_bits = 2^constellation_order;
    G1 = [1 1 0 0;
          0 1 1 0;
          0 0 1 1;
          0 0 0 1];
    G2 = [1 1;
          0 1];
    n_words = length(c)/n_bits;
    w = reshape(c, [n_bits n_words])';
    % QAM -- cut data word in half, gray mapping, BIN to DEC conversion, cartesian mapping, offset/rescale
    c = [mod(w(:,1:end/2)*G2, 2) mod(w(:,end/2+1:end)*G2, 2)];
    y = ( (bi2de(c(:,1:end/2), 'left-msb')*2-3) + 1j*(bi2de(c(:,end/2+1:end), 'left-msb')*2-3) ) / sqrt(3^2+1);
    % graphical output
    if showflag
        plot(real(y), imag(y), 'o');
    end
end