function d = map2symbols(c, constellation_order, switch_graph)
  if isempty(c)
     d = []; 
  else
    % determine parameters
    M = length(c)/constellation_order; ... number of data words
    k1 = 2^(constellation_order/2)-1; ... offset correction
    k2 = sqrt(2*(2^constellation_order-1)/3); ... power normalization
    
    % QAM -- cut data word in half, gray mapping, BIN to DEC conversion, cartesian mapping, offset/rescale
    
    % reshape input chunk
    w = reshape(c, [constellation_order M]);
    
    % generator matrix
    G = tril(ones(constellation_order/2));
    
    % gray mapping for QAM symbols
    c = [mod(G*w(1:end/2,:), 2); mod(G*w(end/2+1:end,:), 2)];
    
    % bin2dec conversion
    I = bi2de(c(1:end/2,:)', 'left-msb');
    Q = bi2de(c(end/2+1:end,:)', 'left-msb');
    
    % compose and normalize complex symbols
    d = (2*I-k1)/k2 + 1j*(2*Q-k1)/k2;
    
    % graphical output
    if switch_graph
      figure;
      plot(real(d), imag(d), 'o');
      TitleString = sprintf('%d-QAM Modulation', 2^constellation_order);
      title(TitleString);
      xlim([-1.2,1.2]);
      ylim([-1.2,1.2]);
      xlabel('Re\{d\}');
      ylabel('Im\{d\}');
  end
  end
end