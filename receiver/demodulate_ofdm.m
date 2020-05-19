function D_tilde = demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph)
  % cut of cyclic prefix
  y = z_tilde(cp_size+1:end);
  N_blocks = length(y)/fft_size;
  D_tilde = reshape(y, [fft_size N_blocks]);
  D_tilde = 1/fft_size*fft(D_tilde);
end