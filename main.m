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
P = [1 1 0 1;
     1 0 1 1;
     0 1 1 1];
parity_check_matrix = [P eye(size(P,1))];
constellation_order = 6;        % 2--> 4QAM; 4-->16QAM; 6-->64QAM
% no. of blocks
N_blocks = (ceil(frame_size/4*7/constellation_order/fft_size)*fft_size/fft_size)*2;
% no. of zeros added after encoding
n_zero_padded_bits = (ceil(frame_size/4*7/constellation_order/fft_size)*fft_size -frame_size/4*7/constellation_order)*constellation_order;
% pseudo random pilot symbols (zadoff-chu sequence)
pilot_symbols = zadoff_chu(7, 2, fft_size/2);
% CP length, FSBF channel has length of 199
cp_size = 256;
oversampling_factor = 20;       % oversampling factor
downsampling_factor = 20;       % downsampling factor

clipping_threshold_tx = 8;      % tx clipping_threshold
clipping_threshold_rx = 1;      % rx clipping_threshold
channel_type = 'FSBF';          % channel type: 'AWGN', 'FSBF'

enable_scfdma = 0;
mapping_mode = 0;

snr_db = 0:1:30;% SNRs in dB
iter = 20;                      % no. of iteration

%% initialize vectors
% You can save the BER result in a vector corresponding to different SNRs
BER_coded0 = zeros(length(snr_db),1);
BER_uncoded0 = zeros(length(snr_db),1);
BER_coded1 = zeros(length(snr_db),1);
BER_uncoded1 = zeros(length(snr_db),1);
%% OFDM transmission
for ii = 1 : length(snr_db) % SNR Loop
    BER_b_tmp0 = 0;
    BER_c_tmp0 = 0;
    BER_b_tmp1 = 0;
    BER_c_tmp1 = 0;
    for jj = 1 : iter      % Frame Loop, generate enough simulated bits
        %% transmitter %%
        
        %generate info bits
        b0 = generate_frame(frame_size, switch_graph);
        b1 = generate_frame(frame_size, switch_graph);
        
        %channel coding
        c0 = encode_hamming(b0, parity_check_matrix, n_zero_padded_bits, switch_off);
        c1 = encode_hamming(b1, parity_check_matrix, n_zero_padded_bits, switch_off);
        
        %modulation
        d0 = map2symbols(c0, constellation_order, switch_graph);
        d1 = map2symbols(c1, constellation_order, switch_graph);
        
        %pilot insertion
        D0 = insert_pilots(d0, fft_size/2, N_blocks, pilot_symbols);
        D1 = insert_pilots(d1, fft_size/2, N_blocks, pilot_symbols);
        
        %ofdm modulation
        z0 = modulate_ofdm(D0, fft_size, cp_size, 0, mapping_mode, enable_scfdma, 0);
        z1 = modulate_ofdm(D1, fft_size, cp_size, 1, mapping_mode, enable_scfdma, 0);
        
        %tx filter
        s0 = filter_tx(z0, oversampling_factor, switch_graph, switch_off);
        s1 = filter_tx(z1, oversampling_factor, switch_graph, switch_off);
        
        %non-linear hardware
        x0 = impair_tx_hardware(s0, clipping_threshold_tx, switch_graph);
        x1 = impair_tx_hardware(s1, clipping_threshold_tx, switch_graph);
        
        %% channel %%  
        x = x0+x1;
        %baseband channel 
        y = simulate_channel(x, snr_db(ii), channel_type);
        
        %% receiver %%     
        
        %rx hardware
        s_tilde = impair_rx_hardware(y, clipping_threshold_rx, switch_graph);
        
        %rx filter
        z_tilde = filter_rx(s_tilde, downsampling_factor, switch_graph, switch_off);
        
        %ofdm demodulation
        D_tilde= demodulate_ofdm(z_tilde, fft_size, cp_size, mapping_mode, enable_scfdma, switch_graph);
        
        %equalizer
        d0_bar = equalize_ofdm(D_tilde, pilot_symbols, enable_scfdma, fft_size, 0, 0);
        d1_bar = equalize_ofdm(D_tilde, pilot_symbols, enable_scfdma, fft_size, 1, 0);

        %demodulation
        c0_hat = detect_symbols(d0_bar, constellation_order, switch_graph);
        c1_hat = detect_symbols(d1_bar, constellation_order, switch_graph);
        
        %channel decoding
        b0_hat = decode_hamming(c0_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph);
        b1_hat = decode_hamming(c1_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph);
        %digital sink
        [BER_b0, BER_c0] = digital_sink(b0, b0_hat, c0, c0_hat);
        [BER_b1, BER_c1] = digital_sink(b1, b1_hat, c1, c1_hat);
        BER_b_tmp0 = BER_b_tmp0 + BER_b0;
        BER_c_tmp0 = BER_c_tmp0 + BER_c0;
        BER_b_tmp1 = BER_b_tmp1 + BER_b1;
        BER_c_tmp1 = BER_c_tmp1 + BER_c1;
    end
    BER_coded0(ii) = BER_b_tmp0/iter;
    BER_uncoded0(ii) = BER_c_tmp0/iter;
    BER_coded1(ii) = BER_b_tmp1/iter;
    BER_uncoded1(ii) = BER_c_tmp1/iter;
end

%% plot BER-SNR figure
figure;
semilogy(snr_db,BER_coded0);
hold on;
semilogy(snr_db,BER_uncoded0,'--');
xlabel('SNR in dB');
ylabel('BER');
legend('Coded','Uncoded');
grid on;
title('BER-SNR')

figure;
semilogy(snr_db,BER_coded1);
hold on;
semilogy(snr_db,BER_uncoded1,'--');
xlabel('SNR in dB');
ylabel('BER');
legend('Coded','Uncoded');
grid on;
title('BER-SNR')
