function c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, switch_off)
  if switch_off || isempty(b)
    c = b;
  else
    if mod(length(b), 4) == 0
      % determine parameters
      k_prtyBits = size(parity_check_matrix,1);
      N_totBits = size(parity_check_matrix, 2);
      n_dataBits = N_totBits - k_prtyBits;
      n_words = length(b)/n_dataBits; ... number of words within input chunk

      G = [1 1 0 1;
         1 0 1 1;
         1 0 0 0;
         0 1 1 1;
         0 1 0 0;
         0 0 1 0;
         0 0 0 1];
      % reshape input block
      w = reshape(b, [n_dataBits n_words]); ... matrix of data words -- one word per column
      % create hamming code by performing matrix multiplication for each word
      c = mod(G*w, 2);
      c = c(:);
      % Append zeros to vector
      c = [c; zeros(n_zero_padded_bits,1)];
    else
      disp('Input length of b must be a multiple of 4')
  end
end

