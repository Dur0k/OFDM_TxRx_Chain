function x = impair_tx_hardware(s, clipping_threshold, switch_graph)
  s_in = s;
  for i = 1:length(s)
    s_abs = abs(s(i));
    % Clip all values greater than clipping_threshold
    if (s_abs > clipping_threshold)
      s(i) = s(i)/s_abs;
    end
  end
  
  x = s;
  if switch_graph == 1
    % Plot output
    figure;
    subplot(2,2,1);
    plot(real(x));
    ylabel('I');
    grid on;
    subplot(2,2,2);
    plot(imag(x));
    ylabel('Q');
    grid on;
    % Plot phase of output and input
    subplot(2,2,[3,4]);
    plot(angle(s_in));
    hold on;
    plot(angle(x));
    grid on;
    legend('Input s','Output x');
    title('Phase');    
    suptitle('Non-Linear Tx Hardware');
  end
end