function build_codebook(K)
% K - struct containing all necessary info.
ratio = 0.05;
buffer = 100;

Fs = 16000;
Ts = 100e-3;
Tb = 10e-3;

p = 8;

q = 12;

dirs = {...
        'data/GO/',...
        'data/HELP/',...
        'data/NO/',...
        'data/STOP/',...
        'data/YES/'...
    };

read_sig = @(fname)fread(fopen(fname),inf,'int16',0,'b');

X = [];

for i = 1:length(dirs)
    dirname = dirs{i};
    files = dir([dirname '*.raw']);
    for j = 1:length(files);
        sig = read_sig([dirname files(j).name]);
        sig = truncate_sig(sig, K.ratio, K.buffer);
        sigs = split_sig(sig, K.Fs, K.Ts, K.Tb);
        lpcs = lpc_sig(sigs, K.p);
        ceps = cep_from_lpc(lpcs, K.q);
        X = cat(1, X, ceps);
        filename = regexp(files(j).name, '.*(?=.raw)', 'match');
        save([dirname filename{1} '_raw_features.mat'], 'ceps');
    end
end

[~,C] = kmeans(X, K.M);

save('data/codebook.mat', 'C');

end