%  --------------------------------------------------------------------------------------------
%   Channel for phase 1 OFDM transmission
%
%   Channel : channel model
% 
% 
%   Calling Syntax	 [output] = simulate_channel(input, snr_db, channel_type);
% 
%   Input parameter	 input         : channel input signal
%                        snr_db        : add white gaussian noise for given SNR
%                        channel_type  : channel type
%                                        'AWGN' additive white Gaussian noise
%                                        'FSBF' frequency selective block fading
%                        
%                
%   Output parameters		output    :   channel output                                         
%  --------------------------------------------------------------------------------------------



%  --------------------------------------------------------------------------------------------
%   Channel for phase 2 SC-FDMA transmission
%
%   Channel_freqoffset : channel block with frequency offset for arbitrary
%   number of transmitters
% 
% 
%   Calling Syntax	[output]  = simulate_channel_freqoffset(input, snr_db, switch_offset)
% 
%   Input parameter		input	: matrix of user signals, one user per row
%                               snr_db  : additive white gaussian noise with given
%                                         SNR (unit signal power per user assumed)
%                               switch_offset  : switch on/off fixed frequency offset
%                                                0 -> off; 1 -> on  
%                
%   Output parameters		output  : channel output (row vector)                                        
%  --------------------------------------------------------------------------------------------