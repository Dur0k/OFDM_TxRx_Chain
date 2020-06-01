function D_tilde = demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph)
  % cut of cyclic prefix
  y = z_tilde(cp_size+1:end);
  N_blocks = floor(length(y)/fft_size);
  y = y(1:fft_size*N_blocks);
  D_tilde = reshape(y, [fft_size N_blocks]);
  % Demodulate OFDM symbols
  D_tilde = fft(D_tilde);
  if switch_graph == 1
    figure; 
    scatter(real(D_tilde(:,2)), imag(D_tilde(:,2)));
    title('OFDM Symbolspace');
    grid;
  end
end