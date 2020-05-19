function d = map2symbols(c, constellation_order, switch_graph)
  if isempty(c)
     d = []; 
  else
    % set parameters
    n_bits = constellation_order;
    n_words = length(c)/n_bits;
    w = reshape(c, [n_bits n_words])';
    % Normalization factor
    qnorm = sqrt(2*(2^constellation_order-1)/3);
    % QAM -- cut data word in half, gray mapping, BIN to DEC conversion, cartesian mapping, offset/rescale
    switch constellation_order
      case 2
        d = ( (bi2de(w(:,1:end/2), 'left-msb')*2-1) + 1j*(bi2de(w(:,end/2+1:end), 'left-msb')*2-1) ) / qnorm;
      case 4
        G = [1 1;
          0 1];
        c = [mod(w(:,1:end/2)*G, 2) mod(w(:,end/2+1:end)*G, 2)];
        d = ( (bi2de(c(:,1:end/2), 'left-msb')*2-3) + 1j*(bi2de(c(:,end/2+1:end), 'left-msb')*2-3) ) / qnorm;
      case 6
        G = [1 1 1;
            0 1 1;
            0 0 1];
        c = [mod(w(:,1:end/2)*G,2) mod(w(:,end/2+1:end)*G,2)];
        d = ( (bi2de(c(:,1:3), 'left-msb')*2-7) + 1j*(bi2de(c(:,4:6), 'left-msb')*2-7) ) / qnorm; 
    end
    
    % graphical output
    if switch_graph
      figure;
      plot(real(d), imag(d), 'o');
    end
end