clear all; close all;

read_sig = @(fname)fread(fopen(fname),inf,'int16',0,'b');

% Go
sig1 = read_sig('test/GO/an409-fcaw-b.raw');

% No
sig2 = read_sig('test/NO/an402-mdms2-b.raw');
sig3 = read_sig('test/NO/an416-fjlp-b.raw');
sig4 = read_sig('test/NO/an443-mmxg-b.raw');
sig5 = read_sig('test/NO/cen8-mjgm-b.raw');

% Stop
sig6 = read_sig('test/STOP/an440-mjgm-b.raw');

% Yes
sig7 = read_sig('test/YES/an442-mmxg-b.raw');

K = hmm_params();
clf = HMMVoiceClassifier(K);

[sym, lprob] = clf.classify_sig(sig1);
fprintf('Signal 1 word: %s, with log prob: %.4f\n\n', sym, lprob);
[sym, lprob] = clf.classify_sig(sig2);
fprintf('Signal 2 word: %s, with log prob: %.4f\n\n', sym, lprob);
[sym, lprob] = clf.classify_sig(sig3);
fprintf('Signal 3 word: %s, with log prob: %.4f\n\n', sym, lprob);
[sym, lprob] = clf.classify_sig(sig4);
fprintf('Signal 4 word: %s, with log prob: %.4f\n\n', sym, lprob);
[sym, lprob] = clf.classify_sig(sig5);
fprintf('Signal 5 word: %s, with log prob: %.4f\n\n', sym, lprob);
[sym, lprob] = clf.classify_sig(sig6);
fprintf('Signal 6 word: %s, with log prob: %.4f\n\n', sym, lprob);
[sym, lprob] = clf.classify_sig(sig7);
fprintf('Signal 7 word: %s, with log prob: %.4f\n\n', sym, lprob);