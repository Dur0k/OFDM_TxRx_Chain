function z_tilde = filter_rx( s_tilde, downsampling_factor, switch_graph, switch_off )

if switch_off
    % exception handling
    z_tilde = s_tilde;
else
    % design filter impulse response
    L = downsampling_factor; ... samples per symbol (up-/downsampling factor for analog simulation)
    beta = 1;
    g = rcosdesign(beta, 24, L, 'sqrt');
    iFiltOrd = length(g)-1;
    % AD conversion and impulse shaping
    d = conv(g,s_tilde);
    % downsampling
    z_tilde = d(1+iFiltOrd:downsampling_factor:end-iFiltOrd)/sqrt(downsampling_factor);
end

% graphical output
if switch_graph
    [H,Omega] = freqz(g,1);
    figure;
    plot(Omega, 20*log10(abs(H)));
    xlim([0 pi]);
    xlabel('\omega/f_s');
    ylabel('|G_{RX}(j\omega)|^2    (log)');
    title('spectral magnitude of g_{RX}');
    
    figure;
    subplot(2,1,1);
    stem(real(z_tilde));
    legend({'Re\{z_{tilde}\}'});
    subplot(2,1,2);
    stem(imag(z_tilde));
    legend({'Im\{z_{tilde}\}'});
    z_p = z_tilde(1:100);
    eyediagram(z_p,2);
end

end