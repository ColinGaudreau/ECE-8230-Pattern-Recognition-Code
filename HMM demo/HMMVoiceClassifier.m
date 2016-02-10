classdef HMMVoiceClassifier < handle
    properties
        hmms;
        statetable;
        K;
    end
    methods
        function obj = HMMVoiceClassifier(varargin)
            
            if nargin > 0
                obj.K = varargin{1};
            else
                obj.K.M = 40;
                obj.K.ratio = 0.05;
                obj.K.buffer = 100;
                obj.K.Fs = 16000;
                obj.K.Ts = 100e-3;
                obj.K.Tb = 10e-3;
                obj.K.p = 8;
                obj.K.q = 12;
            end
            dirs = {...
                'data/GO/',...
                'data/HELP/',...
                'data/NO/',...
                'data/STOP/',...
                'data/YES/'...
            };
            obj.statetable = cell(1,length(dirs));
            
            go.sym = 'go'; go.num = 1;
            help.sym = 'help'; help.num = 2;
            no.sym = 'no'; no.num = 3;
            stop.sym = 'stop'; stop.num = 4;
            yes.sym = 'yes'; yes.num= 5;
            
            obj.statetable{1} = go;
            obj.statetable{2} = help;
            obj.statetable{3} = no;
            obj.statetable{4} = stop;
            obj.statetable{5} = yes;
            
            obj.hmms = cell(1, length(dirs));
            for i = 1:length(dirs)
                hmm = load([dirs{i} 'hmm.mat']);
                obj.hmms{i} = hmm.hmm;
            end
        end
        
        function varargout = classify_sig(obj, sig)
            probs = zeros(1, length(obj.hmms));
            fts = extract_features(sig, obj.K);
            for i = 1:length(probs)
                [~,probs(i)] = hmmdecode(fts, obj.hmms{i}.a, obj.hmms{i}.b);
            end
            [prob,ind] = max(probs);
            sym = obj.statetable{ind}.sym;
            varargout{1} = sym;
            if nargout > 1
                varargout{2} = prob;
            end
        end
        
    end
    
    methods(Static)
        
        function build_model(K)
            fprintf('Clearing cache...\n');
            HMMVoiceClassifier.clear_cached_features();
            
            fprintf('Extracting features and building codebook...\n');
            build_codebook(K);
            pause(2); % make sure everything's saved (change eventually to poll)
            fprintf('Building state sequences from raw feature vectors...\n');
            build_sequences();
            pause(2);
            fprintf('Training HMM model for each word...\n');
            train_word_hmms(K.M);
            pause(2);
        end
        
        function clear_cached_features()
            system('sh ./clear_cached_features.sh');
            pause(2);
        end
    end
end