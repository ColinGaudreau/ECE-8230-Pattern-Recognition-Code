function varargout = get_perceptron_weight(data, labels, varargin)
% Calculate the weight vector a using the
% perceptron algorithm.
% data should be an nxd matrix and labels should be nx1

if nargin > 2
    N = varargin{1};
end

if nargin > 3
    a0 = varargin{2};
else
    a0 = zeros(1, size(data,2));
end

a = a0;
for j = 1:N
    order = randperm(size(data,1));
    data = data(order,:); labels = labels(order);
    for i = 1:length(labels)
        if labels(i)*dot(a,data(i,:)) <= 0
            a = a + labels(i)*data(i,:);
        end
    end
end

varargout{1} = a;

if nargout > 1
    classification = labels.*sum(repmat(a,size(data,1),1) .* data,2);
    classification = length(classification(classification < 0)) / length(classification);
    varargout{2} = classification;
end