function z = modulate_ofdm(D, fft_size, cp_size, switch_graph)
  % Calc ifft for each qam vector in block D
  y = fft_size*ifft(D);
  % Copy cyclic prefix of cp_size in front of y
  y = y(:);
  z = [y(end-cp_size+1:end); y];
  
  if switch_graph
    figure;
    subplot(2,2,1)
    plot(real(z));
    subplot(2,2,2)
    plot(imag(z));
    subplot(2,2,[3 4])
    plot(abs(fft(z)));
  end
end