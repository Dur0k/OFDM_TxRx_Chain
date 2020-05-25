function s = filter_tx( z, oversampling_factor, switch_graph, switch_off )

if switch_off
    % exception handling
    s = z;
else
    % design filter impulse response
    L = 20; ... samples per symbol (up-/downsampling factor for analog simulation)
    beta = 1;
    g = rcosdesign(beta, 24, L, 'sqrt');
    iFiltOrd = length(g)-1;
    % oversampling
    d = [z.'; zeros(oversampling_factor-1, length(z))]*sqrt(oversampling_factor);
    % DA conversion and impulse shaping
    s = conv(g,d(:));
end

% graphical output
if switch_graph
    [H,Omega] = freqz(g,1);
    figure;
    plot(Omega, 20*log10(abs(H)));
    xlim([0 pi]);
    xlabel('\omega/f_s');
    ylabel('|G_{TX}(j\omega)|^2    (log)');
    title('spectral magnitude of g_{TX}');
    
    figure;
    subplot(2,1,1);
    plot(real(reshape([z.'; zeros(oversampling_factor-1, length(z))], [], 1)));
    hold on;
    plot(real(s(1+iFiltOrd/2:end-iFiltOrd/2)), 'r');
    legend({'Re\{d(t)\} sharp pulses' 'Re\{s(t)\} shaped pulses'});
    subplot(2,1,2);
    plot(imag(reshape([z.'; zeros(oversampling_factor-1, length(z))], [], 1)));
    hold on;
    plot(imag(s(1+iFiltOrd/2:end-iFiltOrd/2)), 'r');
    legend({'Im\{d(t)\} sharp pulses' 'Im\{s(t)\} shaped pulses'});
end

end