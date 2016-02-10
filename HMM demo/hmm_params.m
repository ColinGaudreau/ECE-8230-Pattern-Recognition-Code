function K = hmm_params()
% get params for building hmm model
K.M = 40;
K.ratio = 0.05;
K.buffer = 100;
K.Fs = 16000;
K.Ts = 100e-3;
K.Tb = 10e-3;
K.p = 8;
K.q = 12;
end