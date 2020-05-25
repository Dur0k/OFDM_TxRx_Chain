clear; close all; clc

%% input
% parameter setting
iNmbrSmbls = 2^6;
L = 20; ... samples per symbol (up-/downsampling factor for analog simulation)
nQAM = 64;

% generate 16-QAM signal of digital symbols
d_IQ = randi(sqrt(nQAM), iNmbrSmbls, 2)*2-sqrt(nQAM)-1;
d_tx = d_IQ * [1; 1j] * sqrt(3/(2*(nQAM-1)));
fprintf('squared RMS value (power) of d_rx:\t\t%f\n', mean(abs(d_tx).^2));

% design filter impulse response
beta = 1;
g = rcosdesign(beta, 24, L, 'sqrt');
iFiltOrd = length(g)-1;

%% processing
% DA conversion
u = [d_tx.'; zeros(L-1, length(d_tx))]*sqrt(L); ... oversampling in order to emulate DA conversion
fprintf('squared RMS value (power) of u:\t\t\t%f\n', mean(abs(u(:)).^2));

% tx filter
v = conv(g, u(:));
v = v(1+iFiltOrd/2:end-iFiltOrd/2);
fprintf('squared RMS value (power) of v:\t\t\t%f\n', mean(abs(v).^2));

% rx filter
w = conv(g(end:-1:1), v);
w = w(1+iFiltOrd/2:end-iFiltOrd/2);
fprintf('squared RMS value (power) of w:\t\t\t%f\n', mean(abs(w).^2));

% AD conversion
d_rx = w(1:L:end)/sqrt(L); ... downsampling in order to emulate AD conversion
fprintf('squared RMS value (power) of d_rx:\t\t%f\n', mean(abs(d_rx).^2));

%% output
figure;
stem(g);
xlabel('k');
ylabel('g(k)');
title(sprintf('sum(g) = %f, sqrt(sum(g^2)) = %f', sum(g), sqrt(sum(g.^2))));
movegui('southwest');

figure;
subplot(2,1,1);
plot(real(u(:)), 'b');
hold on;
plot(real(v), 'g');
legend({'Re\{u\}' 'Re\{v\}'});
subplot(2,1,2);
plot(imag(u(:)), 'b');
hold on;
plot(imag(v), 'g');
legend({'Im\{u\}' 'Im\{v\}'});
movegui('northwest');eyediagram(w(1+L:end-L), L, L, 0);


figure;
subplot(2,1,1);
plot(real(v), 'g');
hold on;
plot(real(w), 'r');
legend({'Re\{v\}' 'Re\{w\}'});
subplot(2,1,2);
plot(imag(v), 'g');
hold on;
plot(imag(w), 'r');
legend({'Im\{v\}' 'Im\{w\}'});
movegui('north');

figure;
subplot(2,1,1);
stem(real(d_tx), 'c');
hold on;
stem(real(d_rx), '--m');
legend({'Re\{d_{TX}\}' 'Re\{d_{RX}\}'});
subplot(2,1,2);
stem(imag(d_tx), 'c');
hold on;
stem(imag(d_rx), '--m');
legend({'Im\{d_{TX}\}' 'Im\{d_{RX}\}'});
movegui('northeast');

figure;
[G,Omega] = freqz(g,1);
plot(Omega, 20*log10(abs(G)));
xlabel('\omega/(L\cdotf_s)');
ylabel('|G(j\omega)|^2   (log)');
movegui('south');

eyediagram(w(1+L:end-L), L, L, 0);
movegui('southeast');