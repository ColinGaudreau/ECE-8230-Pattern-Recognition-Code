function ftr = extract_features(sig, K)
% extract features from sig
%
% K - struct with all necessary info.

sig = truncate_sig(sig, K.ratio, K.buffer);
sigs = split_sig(sig, K.Fs, K.Ts, K.Tb);
lpcs = lpc_sig(sigs, K.p);
ceps =cep_from_lpc(lpcs, K.q);

C = load('data/codebook.mat');
C = C.C;

ftr = find_nearest_code_seq(ceps, C);

end