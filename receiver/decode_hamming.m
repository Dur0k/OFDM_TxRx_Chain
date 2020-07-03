function b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph)
  if switch_off || isempty(c_hat)
    b_hat = c_hat;
  else
    % Remove n_zero_padded_bits
    c_hat = c_hat(1:end-n_zero_padded_bits);
    if mod(length(c_hat), 7) == 0
      % Determine parameters
      k_prtyBits = size(parity_check_matrix,1);
      N_totBits = size(parity_check_matrix, 2);
      n_dataBits = N_totBits - k_prtyBits;
      n_words = length(c_hat)/N_totBits; ... number of words within input chunk

      % Create reconstruction matrix
      R = [eye(n_dataBits) zeros(n_dataBits,k_prtyBits)]; ... derived by parity check matrix

      % Reshape input block
      c = reshape(c_hat, [N_totBits n_words]); ... matrix of data words -- one word per column

      % Error detection
      s = mod(parity_check_matrix*c,2); ... syndrome vectors
      [~,z] = ismember(s',parity_check_matrix', 'rows'); ... column position of syndrom in check matrix

      % Error correction
      e = zeros(N_totBits, n_words);
      e(sub2ind(size(e), z(z>0), find(z>0))) = 1; ... faulty bit positions per word
      w = mod(c+e, 2); ... flip 1 bit in each word
      
      % Reconstruct data words from hamming code by performing matrix
      % multiplication for each word
      b_hat = mod(R*w, 2);
      b_hat = b_hat(:);
    else
      disp('Input length of b must be a multiple of 4')
    end
  end
  % graphical output
  if switch_graph
        hFig = findobj('Tag', 'hamming');
        if isempty(hFig)
            hFig = figure('Tag', 'hamming');
            set(gca, 'box', 'on', 'nextplot', 'add');
            title('Erroneous bits in hamming code frame marked with an ''x''');
        end
        figure(hFig);
        stem(w(:));
        idx = find(w-c~=0);
        stem(idx, r(idx), 'x');
   end
end