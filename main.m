%% This is main.m example for ICT Lab2
% 
%  In this file, all main parameters are defined and all functions are 
%  called for the phase 1 (OFDM transmission). Please refer to this 
%  structure to write your code. For phase 2, some changes should be 
%  made to consider new parameters and requirements.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear;clc;

%% define parameters

% switch_graph =                  % 1/0--> show/not show the graph
% switch_off =                    % 1/0--> switch off/on the block

% fft_size =                      % FFT length /OFDM symbol length
% N_blocks =                      % no. of blocks
% parity_check_matrix =           % code parity check matrix
% constellation_order =           % 2--> 4QAM; 4-->16QAM; 6-->64QAM
% frame_size =                    % frame length
% n_zero_padded_bits =            % no. of zeros added after encoding
% pilot_symbol =                  % generated pilot symbols 
% cp_size =                       % CP length
% oversampling_factor =           % oversampling factor
% downsampling_factor =           % downsampling factor
%
% clipping_threshold_tx =         % tx clipping_threshold
% clipping_threshold_rx =         % rx clipping_threshold
% channel_type =                  % channel type: 'AWGN', 'FSBF'
%
% snr_db =                        % SNRs in dB
% iter =                          % no. of iteration

%% initialize vectors
% You can save the BER result in a vector corresponding to different SNRs

% BER_uncoded =
% BER_coded =

%% OFDM transmission

for ii = 1 : length(snr_db) % SNR Loop
    for jj = 1 : iter      % Frame Loop, generate enough simulated bits
        %% transmitter %%
        
        %generate info bits
        b = generate_frame(frame_size, switch_graph);
        
        %channel coding
        c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, switch_off);
        
        %modulation
        d = map2symbols(c, constellation_order, switch_graph);
        
        %pilot insertion
        D = insert_pilots(d, fft_size, N_blocks, pilot_symbol);
        
        %ofdm modulation
        z = modulate_ofdm(D, fft_size, cp_size, switch_graph);
        
        %tx filter
        s = filter_tx(z, oversampling_factor, switch_graph, switch_off);
        
        %non-linear hardware
        x = impair_tx_hardware(s, clipping_threshold_tx, switch_graph);
        
        %% channel %%  
        
        %baseband channel 
        y = simulate_channel(x, snr_db, channel_type);
        
        %% receiver %%     
        
        %rx hardware
        s_tilde = impair_rx_hardware(y, clipping_threshold_rx, switch_graph);
        
        %rx filter
        z_tilde = filter_rx(s_tilde, downsampling_factor, switch_graph, switch_off);
        
        %ofdm demodulation
        D_tilde= demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph);
        
        %equalizer
        d_bar = equalize(D_tilde, pilot_symbol, switch_graph);
        
        %demodulation
        c_hat = detect_symbols(d_bar, constellation_order, switch_graph);
        
        %channel decoding
        b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph);
        
        %digital sink
        BER = digital_sink(b, b_hat);
        
    end
end

%% plot BER-SNR figure
%     figure;
%     plot()



