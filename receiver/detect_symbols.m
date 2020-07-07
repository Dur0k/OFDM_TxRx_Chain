function c_hat = detect_symbols(d_bar, constellation_order, switch_graph)
  if isempty(d_bar)
     c_hat = []; 
  else
      % determine parameters
      k1 = 2^(constellation_order/2)-1; ... offset correction
      k2 = sqrt(2*(2^constellation_order-1)/3); ... power normalization
      
      % generator matrix
      G = tril(ones(constellation_order/2));
      
      % denormalize and detect complex symbols
      I = round((real(d_bar)*k2+k1)/2);
      I(I<0) = 0;
      I(I>k1) = k1;
      Q = round((imag(d_bar)*k2+k1)/2);
      Q(Q<0) = 0;
      Q(Q>k1) = k1;
      
      % dec2bin conversion
      c = [de2bi(I, constellation_order/2, 'left-msb')'; de2bi(Q, constellation_order/2, 'left-msb')'];

      % reverse gray mapping for QAM symbols
      w = [mod(G\c(1:end/2,:), 2); mod(G\c(end/2+1:end,:), 2)];
      c_hat = w(:);
  end  
  % graphical output
  if switch_graph
      figure;
      plot(real(d_bar), imag(d_bar), 'o');
      set(gca, 'box', 'on', 'nextplot', 'add', 'XGrid', 'on', 'XTick', (2*(0.5:2^(constellation_order/2)-1.5)-k1)/k2, 'YGrid', 'on', 'YTick', (2*(0.5:2^(constellation_order/2)-1.5)-k1)/k2);
      title('Estimated symbol constellation');
      xlabel('Re\{d_{bar}\}');
      ylabel('Im\{d_{bar}\}');
  end
end

      
