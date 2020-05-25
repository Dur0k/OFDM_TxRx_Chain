% Test file to show clipping on upswinging exponential function
clear all;
close all;
addpath('transmitter/');
clipping_threshold = [1.0 1.3]

t = 0:0.01:128;
s = 1.5*exp(2j*pi*t*0.02/0.1) .*sin(2*pi*t*0.0002/0.1);
for i=1:length(clipping_threshold)
    x = impair_tx_hardware(s, clipping_threshold(i), 1);
end
