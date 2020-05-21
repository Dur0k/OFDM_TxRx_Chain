function s_tilde = impair_rx_hardware(y, clipping_threshold, switch_graph)
  y_in = y
  for i = 1:length(y)
    y_abs = abs(y(i));
    if (y_abs > par_rxthresh)
      y(i) = y(i)/y_abs;
      end
    end
  s_tilde = y;
    
  if switch_graph == 1
    % Plot output
    figure;
    subplot(2,2,1);
    plot(real(s_tilde));
    title('Non-Linear Rx Hardware');
    ylabel('I');
    grid on;
    subplot(2,2,2);
    plot(imag(s_tilde));
    ylabel('Q');
    grid on;
    % Plot phase of output and input
    W = (2*pi/length(s_tilde)) * [ 0:(length(s_tilde)-1) ]';
    mid = ceil(length(s_tilde)/2) + 1;
    W(mid:length(s_tilde)) = W(mid:length(s_tilde)) - 2*pi;
    W = fftshift(W)./pi;
    S_in = fftshift(fft(y_in)/length(y_in));
    X = fftshift(fft(s_tilde)/length(s_tilde));
    subplot(2,2,[3,4]);
    plot(W,angle(y_in));
    hold on;
    plot(W,angle(X));
    grid on;
    legend('Input y','Output s');
    title('Phase');
    end
end