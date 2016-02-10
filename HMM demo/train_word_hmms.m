function train_word_hmms(M)
% builds the hmms for each word
%
% M - Codebook size

dirs = {...
        'data/GO/',...
        'data/HELP/',...
        'data/NO/',...
        'data/STOP/',...
        'data/YES/'...
    };

for i = 1:length(dirs)
    feats = load([dirs{i} 'features.mat']);
    feats = feats.seqs;
    a0 = ones(1); b0 = ones(1, M);
    [a,b] = hmmtrain(feats, a0, b0);
    hmm.a = a; hmm.b = b;
    save([dirs{i} 'hmm.mat'], 'hmm');
end

end