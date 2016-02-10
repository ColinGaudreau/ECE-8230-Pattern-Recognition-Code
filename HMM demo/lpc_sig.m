function lpc_sigs = lpc_sig(sigs, p)

lpc_sigs = cell(1, length(sigs));

for i=1:length(sigs)
    lpc_sigs{i} = lpc(sigs{i}, p);
end

end