function sig = truncate_sig(sig, ratio, buffer)

ind = sig > ratio * max(sig);

first_ind = max(1,find(ind, 1, 'first') - buffer);
last_ind = min(length(sig), find(ind, 1, 'last') + buffer);

sig = sig(first_ind:last_ind);

end