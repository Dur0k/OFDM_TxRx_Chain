function d_bar = equalize_ofdm(D_tilde, pilot_symbols, enable_scfdma, fft_size, user_id, switch_graph)
  if user_id == 0
      D_tilde = D_tilde(1:length(D_tilde)/2,:);
  elseif user_id == 1
      D_tilde = D_tilde(length(D_tilde)/2+1:end,:);
  end
  % Calculate equalization factor
  eq = pilot_symbols./D_tilde(:,1);
  % Remove pilot
  D_tilde = D_tilde(:,2:end);
  d_plot = D_tilde;
  % Equalize
  D_tilde = D_tilde.*eq;
  
  if enable_scfdma
      % Divide in subsequences of length N=fft_size/2=size(D,1)/2
      D_tilde = reshape(D_tilde,size(D_tilde,1)/2,size(D_tilde,2)*2);
      % Calculate ifft of of length N
      D_tilde = ifft(D_tilde,fft_size/4)*sqrt(fft_size/4);
      D_tilde = reshape(D_tilde,size(D_tilde,1)*2,size(D_tilde,2)/2);
  end
  
  d_bar = D_tilde(:);
  if switch_graph == 1
    % Compare input and output symbols
    figure;
    plot(real(d_plot), imag(d_plot), 'o');
    hold on;
    plot(real(d_bar), imag(d_bar), 'x'); 
    title(['user ',num2str(user_id),', o input, x output']);
  end
end