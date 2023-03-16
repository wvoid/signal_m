function [Gaussian_filter_q] = Gaussian_filter(B, symb_rate, delay, ts)
% INPUTS:
%   B         : the 3dB bandwidth of Gaussian filter
%   symb_rate : rate of the symbol, in ble it is 1e6 symbol/s
%   delay     : it controls how many symbols the Gaussian filter cover
%   ts        : the reciprocal of sample rate
  symb_T  = 1 / symb_rate;
  Gau_t   = -delay*symb_T:ts:delay*symb_T;
  K       = 2*pi*B / sqrt(log(2));
  Gau_det = K.*(Gau_t - symb_T / 2);
  Gau_sum = K.*(Gau_t + symb_T / 2);
  Gaussian_filter_q = 1/(2*symb_T)*[qfunc(Gau_det)-qfunc(Gau_sum)];
end
