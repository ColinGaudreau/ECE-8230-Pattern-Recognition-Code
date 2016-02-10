function vec = find_nearest_code_seq(X, C)
% find closest sequence of states in codebook C using euclidean norm

vec = zeros(1, size(X,1));

for i = 1:length(vec)
    x = repmat(X(i,:), size(C,1), 1);
    dists = sum((x - C).^2, 2);
    [~, inds] = sort(dists);
    vec(i) = inds(1);
end
end