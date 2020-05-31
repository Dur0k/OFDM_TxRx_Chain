%% This is main.m example for ICT Lab2
% 
%  In this file, all main parameters are defined and all functions are 
%  called for the phase 1 (OFDM transmission). Please refer to this 
%  structure to write your code. For phase 2, some changes should be 
%  made to consider new parameters and requirements.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear;clc;
addpath('transmitter/');
addpath('receiver/');
addpath('channel/');

%% define parameters

switch_graph = 0;               % 1/0--> show/not show the graph
switch_off =  0;                % 1/0--> switch off/on the block

fft_size = 1024;                % FFT length /OFDM symbol length
frame_size = 27*256;            % frame length
parity_check_matrix = [1 0 1 0 1 0 1;
                       0 1 1 0 0 1 1;
                       0 0 0 1 1 1 1];           % code parity check matrix
constellation_order = 2;        % 2--> 4QAM; 4-->16QAM; 6-->64QAM
N_blocks = (ceil(frame_size/4*7/constellation_order/fft_size)*fft_size/fft_size);                     % no. of blocks

n_zero_padded_bits = (ceil(frame_size/4*7/constellation_order/fft_size)*fft_size -frame_size/4*7/constellation_order)*constellation_order;            % no. of zeros added after encoding
%pilot_symbols = ones(fft_size, 1) * (0.7071 + 0.7071i);
%pilot_symbols(1:2:end) = ones(fft_size/2, 1) * (-0.7071 - 0.7071i);                  % generated pilot symbols 
u = 7; % 
q = 2; % cyc shift
N = fft_size; % length
n = (0:N-1);
pilot_symbols = exp(-1j*pi*u*n.*(n+mod(N,2)+2*q)/N).';
cp_size = fft_size/8;           % CP length
oversampling_factor = 20;       % oversampling factor
downsampling_factor = 20;       % downsampling factor

clipping_threshold_tx = 1.2;      % tx clipping_threshold
clipping_threshold_rx = 1;      % rx clipping_threshold
channel_type = 'FSBF';          % channel type: 'AWGN', 'FSBF'

snr_db = -10:5:30;%[50, 40, 35, 30, 25, 20, 15, 10, 5, 3, 1];  % SNRs in dB
iter = 50;                      % no. of iteration

%% initialize vectors
% You can save the BER result in a vector corresponding to different SNRs

% BER_uncoded =
% BER_coded =

%% OFDM transmission
BER_coded = zeros(length(snr_db),1);
BER_uncoded = zeros(length(snr_db),1);
for ii = 1 : length(snr_db) % SNR Loop
    BER_b_tmp = 0;
    BER_c_tmp = 0;
    for jj = 1 : iter      % Frame Loop, generate enough simulated bits
        %% transmitter %%
        
        %generate info bits
        b = generate_frame(frame_size, switch_graph);
        
        %channel coding
        c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, switch_off);
        
        %modulation
        d = map2symbols(c, constellation_order, switch_graph);
        
        %pilot insertion
        D = insert_pilots(d, fft_size, N_blocks, pilot_symbols);
        
        %ofdm modulation
        z = modulate_ofdm(D, fft_size, cp_size, switch_graph);
        
        %tx filter
        s = filter_tx(z, oversampling_factor, switch_graph, switch_off);
        
        %non-linear hardware
        x = impair_tx_hardware(s, clipping_threshold_tx, switch_graph);
        
        %% channel %%  
        
        %baseband channel 
        y = simulate_channel(x, snr_db(ii), channel_type);
        if (channel_type == 'FSBF')
            y = y(1:end-199);
        end
        
        
        %% receiver %%     
        
        %rx hardware
        s_tilde = impair_rx_hardware(y, clipping_threshold_rx, switch_graph);
        
        %rx filter
        z_tilde = filter_rx(s_tilde, downsampling_factor, switch_graph, switch_off);
        
        %ofdm demodulation
        D_tilde= demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph);
        
        %equalizer
        d_bar = equalize_ofdm(D_tilde, pilot_symbols, switch_graph);
        
        %demodulation
        c_hat = detect_symbols(d_bar, constellation_order, switch_graph);
        
        %channel decoding
        b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph);
        
        %digital sink
        [BER_b, BER_c] = digital_sink(b, b_hat, c, c_hat);
        BER_b_tmp = BER_b_tmp + BER_b;
        BER_c_tmp = BER_c_tmp + BER_c;
    end
    BER_coded(ii) = BER_b_tmp/iter;
    BER_uncoded(ii) = BER_c_tmp/iter;
end

%% plot BER-SNR figure
figure;
semilogy(snr_db,BER_coded);
hold on;
semilogy(snr_db,BER_uncoded,'--');
xlabel('SNR in dB');
ylabel('BER');
legend('Coded','Uncoded');
grid on;
title('BER-SNR')
