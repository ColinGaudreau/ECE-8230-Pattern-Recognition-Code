function find_codebook_seq(C, dirname)
% C - codebook
% dirname - directory where raw features are stored

files = dir([dirname '*.mat']);

seqs = cell(1, length(files));

for i = 1:length(seqs)
    ceps = load([dirname files(i).name]);
    ceps = ceps.ceps;
    seqs{i} = find_nearest_code_seq(ceps, C);
end

save([dirname 'features.mat'], 'seqs');

end