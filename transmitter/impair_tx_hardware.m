function x = impair_tx_hardware(s, clipping_threshold, switch_graph)
  s_in = s;
  for i = 1:length(s)
    s_abs = abs(s(i));
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
    title('Non-Linear Tx Hardware');
    ylabel('I');
    grid on;
    subplot(2,2,2);
    plot(imag(x));
    ylabel('Q');
    grid on;
    % Plot phase of output and input
    W = (2*pi/length(x)) * [ 0:(length(x)-1) ]';
    mid = ceil(length(x)/2) + 1;
    W(mid:length(x)) = W(mid:length(x)) - 2*pi;
    W = fftshift(W)./pi;
    S_in = fftshift(fft(s_in)/length(s_in));
    X = fftshift(fft(x)/length(x));
    subplot(2,2,[3,4]);
    plot(W,angle(S_in));
    hold on;
    plot(W,angle(X));
    grid on;
    legend('Input s','Output x');
    title('Phase');
  end
end