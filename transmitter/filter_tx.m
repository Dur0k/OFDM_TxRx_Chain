function s = filter_tx( z, oversampling_factor, switch_graph, switch_off )

if switch_off
    % exception handling
    s = z;
else
%     design filter impulse response
    [iFiltOrd,fo,ao,w] = firpmord([0.4 0.6], [1 0], [10^(-3/20) 10^(-45/20)]);
    iFiltOrd = ceil(iFiltOrd/2)*2; ... ceil to next even order
    h = firpm(iFiltOrd, fo, ao, w);
    g = h/sqrt(sum(h.^2));
    % oversampling
    d = [z.'; zeros(oversampling_factor-1, length(z))];
    % DA conversion and impulse shaping
    s = conv(g,d(:))*oversampling_factor/sum(g);
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
end

end
