function sigs = split_sig(sig, Fs, Ts, Tb)

Ns = floor(Ts*Fs);
Nb = floor(Tb*Fs);

li = 1; count = 1;
sigs = cell(1, length(sig));
while li < length(sig)
    lf = min(length(sig), li + Ns - 1);
    sigs{count} = sig(li:lf);
    li = li + Ns + Nb - 1;
    count = count + 1;
end

sigs = sigs(cellfun(@(arr) ~isempty(arr), sigs));
end