function w = find_fisher_opt_plane(dsets)
%   Finds optimal plane using Fisher's criterion
% the data sets found in the cx1 cell array dsets
%
% each cell is the ni x d data for class i
% Cacluted between and within class covariance
% and finds the eigenvector corresponding to the
% maximal eigenvalue of S_W^-1 S_B.

S_B = get_between_class_cov(dsets);

S_W = [];
dset_tot = cell2mat(dsets);

for dset = dsets
    dset = dset{1};
    tmp = get_within_class_cov(dset);
    if isempty(S_W)
        S_W = size(dset,1)/size(dset_tot,1) * tmp;
    else
        S_W = S_W + size(dset,1)/size(dset_tot,1) * tmp;
    end
end

maxmat = inv(S_W) * S_B;

[V,D] = eig(maxmat);
[~,ind] = max(diag(D));
w = V(:,ind);

    function S_B = get_between_class_cov(dsets)
        dtot = cell2mat(dsets);
        N = size(dtot,1);
        mean = sum(dtot,1)/N;
        S_B = [];
        for dset = dsets
            dset = dset{1};
            dset_N = size(dset,1);
            dset_mean = sum(dset,1) / dset_N;
            tmp = dset_N/N * ((dset_mean - mean)' * (dset_mean - mean));
            
            if isempty(S_B)
                S_B = tmp;
            else
                S_B = S_B + tmp;
            end
        end
    end

    function S_class = get_within_class_cov(dset)
        N = size(dset,1);
        mean = sum(dset, 1) / N;
        S_class = [];
        for i = 1:size(dset,1)
            tmp = dset(i,:) - mean;
            tmp = tmp' * tmp;
            if isempty(S_class)
                S_class = tmp;
            else
                S_class = S_class + tmp;
            end
        end
        S_class = S_class / N;
    end
end
