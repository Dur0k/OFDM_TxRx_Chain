function D_tilde = demodulate_ofdm(z_tilde, fft_size, cp_size, mapping_mode, enable_scfdma, switch_graph)
  % cut of cyclic prefix
  N_blocks = floor(length(z_tilde)/(fft_size+cp_size));
  y = reshape(z_tilde,fft_size+cp_size,N_blocks);
  D_tilde = y(cp_size+1:end,:);
  % Demodulate OFDM symbols
  D_tilde = fft(D_tilde,fft_size)/sqrt(fft_size);
 
  % User data allocation reversal
  % Alternating mapping
  if mapping_mode == 1
      D_tilde = [D_tilde(1:2:end,:);D_tilde(2:2:end,:)];
  end

  if switch_graph == 1
    D0 = D_tilde(1:fft_size/2,2:end);
    D1 = D_tilde(fft_size/2+1:end,2:end);
    figure; 
    scatter(real(D0(:)), imag(D0(:)));
    title('OFDM Symbolspace User 0');
    grid;
    figure; 
    scatter(real(D1(:)), imag(D1(:)));
    title('OFDM Symbolspace User 1');
    grid;
  end
end
