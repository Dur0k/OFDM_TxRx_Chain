function s = filter_tx(z, oversampling_factor, switch_graph, switch_off)
  zero_vec = zeros(oversampling_factor-1,length(z));
  tmp = [z.';zero_vec];
  z_up = tmp(:);
  %b = fir1(64,0.4,hamming(65));
  b = fir1(61,3328/(3328/2),'low');
  s = filter(b,1,z_up);
  figure;
  [psd,f] = periodogram(s, rectwin(length(s)), length(s)*2,length(s));
  plot(fftshift(f),10*log10(fftshift(psd)));
end