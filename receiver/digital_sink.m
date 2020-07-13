function [BER_b, BER_c, PAPR] = digital_sink(b, b_hat, c, c_hat, x, fft_size, cp_size, oversampling_factor)
  if isempty(c_hat) | isempty(b_hat) | isempty(x)
      BER_c = 0;
      BER_b = 0;
      PAPR = 0;
  else
      % Uncoded BER
      if length(c) > length(c_hat)
          len = length(c_hat);
      else
          len = length(c);
      end
      BER_c = sum(sum(abs(c(1:len)-c_hat(1:len))))/(4*len/7);
      % Coded BER
      if length(b) > length(b_hat)
          len = length(b_hat);
      else
          len = length(b);
      end
      BER_b = sum(abs(b(1:len)-b_hat(1:len)))/len;
      
      % PAPR per OFDMA/SC-FDMA symbol
      % Reshape non-linear hardware output to ofdm symbol length
      % with oversampling and CP included
      N_blocks = floor(length(x)/((fft_size+cp_size)*oversampling_factor));
      x = x(1:N_blocks*(fft_size+cp_size)*oversampling_factor);
      x = reshape(x,(fft_size+cp_size)*oversampling_factor,N_blocks);
      % Calc PAPR
      x_max = max(abs(x)).^2;
      x_mean = mean(abs(x).^2);
      PAPR = x_max./x_mean;
  end
end