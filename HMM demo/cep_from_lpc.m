function ceps = cep_from_lpc(lpcs, q)

ceps = zeros(length(lpcs), q);

H = dsp.LPCToCepstral('CepstrumLength', q);
for i = 1:length(lpcs)
   ceps(i,:) = step(H, lpcs{i}')';
end

release(H);