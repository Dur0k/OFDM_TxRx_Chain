function b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph)
  if switch_off || isempty(c_hat)
    b_hat = c_hat;
  else
    % Remove n_zero_padded_bits
    c_hat = c_hat(1:end-n_zero_padded_bits);
    if mod(length(c_hat), 7) == 0
      % determine parameters
      k_prtyBits = size(parity_check_matrix,1);
      N_totBits = size(parity_check_matrix, 2);
      n_dataBits = N_totBits - k_prtyBits;
      n_words = length(c_hat)/N_totBits; ... number of words within input chunk
      % reshape input block
      c = reshape(c_hat, [N_totBits n_words]); ... matrix of data words -- one word per column
      R = [0 0 1 0 0 0 0;
          0 0 0 0 1 0 0;
          0 0 0 0 0 1 0;
          0 0 0 0 0 0 1];
      
      z = bi2de(mod(c'*parity_check_matrix', 2));
      e = zeros(size(c));
      e(sub2ind(size(e), z(z>0), find(z>0))) = 1;
      w = mod(c+e, 2);
      b_hat = mod(w'*R', 2)';
      b_hat = b_hat(:);
    else
      disp('Input length of b must be a multiple of 4')
    end
  end
  if switch_graph
      figure;
      %plot(real(d), imag(d), 'o');
  end
end