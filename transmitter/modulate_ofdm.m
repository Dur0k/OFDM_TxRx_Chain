function z = modulate_ofdm(D, fft_size, cp_size, switch_graph)
  % Calc ifft for each qam vector in block D
  y = ifft(D,fft_size)*fft_size;%
  % Copy cyclic prefix of cp_size in front of y
  y = y(:);
  z = [y(end-cp_size+1:end); y];
  
  
  if switch_graph
    figure;
    subplot(2,2,1)
    plot(real(z));
    title('real(z)');
    subplot(2,2,2)
    plot(imag(z));
    title('imag(z)');
    subplot(2,2,[3 4])
    [psd,f] = periodogram(z, rectwin(length(z)), fft_size*10,length(z));
    plot(f,10*log10(psd));
    title('Spectrum of z');
    suptitle('OFDM Modulation');
  end
end