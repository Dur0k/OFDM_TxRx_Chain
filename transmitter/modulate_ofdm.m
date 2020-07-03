function z = modulate_ofdm(D, fft_size, cp_size, user_id, mapping_mode, enable_scfdma, switch_graph)
  if enable_scfdma
      % Remove pilot before precoding
      pilot = D(:,1);
      D = D(:,2:end);
      % DFT precoding
      % Divide in subsequences of length N=fft_size/2=size(D,1)/2
      D = reshape(D,size(D,1)/2,size(D,2)*2);
      % Calculate fft of of length N
      D = fft(D,fft_size/4)/sqrt(fft_size/4);
      D = reshape(D,size(D,1)*2,size(D,2)/2);
      % Add pilot again
      D = [pilot, D];
  end
  % User data allocation
  % Block resource mapping
  if mapping_mode == 0
      if user_id == 0
          D = [D;zeros(size(D))];
      elseif user_id == 1
          D = [zeros(size(D));D];
      end
  % Alternating mapping
  elseif mapping_mode == 1
      if user_id == 0
          Dz = zeros(size(D,1)*2, size(D,2));
          Dz(1:2:end,1:end) = D(:,:);
          D = Dz;
      elseif user_id == 1
          Dz = zeros(size(D,1)*2, size(D,2));
          Dz(2:2:end,1:end) = D(:,:);
          D = Dz;
      end
  end
      % Calc ifft for each qam vector in block D
      y = ifft(D,fft_size)*sqrt(fft_size);
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