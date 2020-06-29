function D_tilde = demodulate_ofdm(z_tilde, fft_size, cp_size, mapping_mode, enable_scfdma, switch_graph)
  % cut of cyclic prefix
  y = z_tilde(cp_size+1:end);
  N_blocks = floor(length(y)/fft_size);
  y = y(1:fft_size*N_blocks);
  D_tilde = reshape(y, [fft_size N_blocks]);
  % Demodulate OFDM symbols
  D_tilde = fft(D_tilde,fft_size)/fft_size;
  
  % User data allocation
  % Block resource mapping
  if mapping_mode == 1
      D_tilde = [D_tilde(1:2:end,:);D_tilde(2:2:end,:)];
  end
  
  if enable_scfdma
      % Divide in subsequences of length N=fft_size/2=size(D,1)/2
      D_tilde = reshape(D_tilde,size(D_tilde,1)/4,size(D_tilde,2)*4);
      % Calculate ifft of of length N
      D_tilde = ifft(D_tilde,fft_size/4)/fft_size/4;
      D_tilde = reshape(D_tilde,size(D_tilde,1)*4,size(D_tilde,2)/4);
  end
  
  if switch_graph == 1
    figure; 
    scatter(real(D_tilde(:,2)), imag(D_tilde(:,2)));
    title('OFDM Symbolspace');
    grid;
  end
end