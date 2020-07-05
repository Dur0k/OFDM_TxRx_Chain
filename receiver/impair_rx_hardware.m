function s_tilde = impair_rx_hardware(y, clipping_threshold, switch_graph)
  % pass through the signal
  s_tilde = y.';
  if switch_graph == 1
    % Plot output
    figure;
    subplot(2,2,1);
    plot(real(s_tilde));
    ylabel('I');
    grid on;
    subplot(2,2,2);
    plot(imag(s_tilde));
    ylabel('Q');
    grid on;
    % Plot phase
    subplot(2,2,[3,4]);
    plot(angle(s_tilde));
    hold on;
    title('Phase');
    suptitle('Non-Linear Rx Hardware');
  end
end