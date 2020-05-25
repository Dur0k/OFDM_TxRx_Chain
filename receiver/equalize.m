function d_bar = equalize(D_tilde, pilot_symbols, switch_graph)
  % Calculate equalization factor
  eq = pilot_symbols./D_tilde(:,1);
  % Remove pilot
  d_plot = D_tilde(:,2:end);
  % Equalize
  d_bar = d_plot.*eq;
  d_bar = d_bar(:);

  if switch_graph == 1
    % Compare input and output symbols
    figure;
    plot(real(d_plot), imag(d_plot), 'o');
    hold on;
    plot(real(d_bar), imag(d_bar), 'x'); 
  end
end