function [BER_b, BER_c] = digital_sink(b, b_hat, c, c_hat)
  if isempty(c_hat) | isempty(b_hat)
   BER_c = 0;
   BER_b = 0;
  else
    % Uncoded BER
    if length(c) > length(c_hat)
        len = length(c_hat);
    else
        len = length(c);
    end
   BER_c = sum(sum(abs(c(1:len)-c_hat(1:len))))/len;
   % Uncoded BER
   if length(b) > length(b_hat)
     len = length(b_hat);
   else
     len = length(b);
   end
   BER_b = sum(abs(b(1:len)-b_hat(1:len)))/len;
end