function D = insert_pilots(d, fft_size, N_blocks, pilot_symbols)
  % reshape vector d into  fft_size x N_blocks matrix
  D = reshape(d, [fft_size N_blocks]);
  % add pilot column vector(fft_size) to matrix D
  D = [pilot_symbols D];
end