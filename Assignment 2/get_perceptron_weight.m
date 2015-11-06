function varargout = get_perceptron_weight(data, labels, varargin)
% Calculate the weight vector a using the
% perceptron algorithm.
% data should be an nxd matrix and labels should be nx1

data = cat(2,data,ones(size(data,1),1));
MAX_ITERATION = 10000;

if nargin > 2
    a0 = varargin{1};
else
    a0 = zeros(1, size(data,2));
end

if nargin > 3
    MAX_ITERATION = varargin{2};
end

a = a0;

count = 0;
should_stop = false;
while ~should_stop    
    for i = 1:length(labels)
        if labels(i)*dot(a,data(i,:)) <= 0
            a = a + labels(i)*data(i,:);
            
            count = count + 1;
            should_stop = classification_error(a, data, labels) == 0;
            if should_stop
                break;
            end
        end
    end
    
    should_stop = should_stop || count > MAX_ITERATION;
end

varargout{1} = a;

if nargout > 1
    varargout{2} = count;
end

if nargout > 2
    varargout{3} = classification_error(a, data, labels);
end

    function err = classification_error(a, data, labels)
        err = labels.*sum(repmat(a,size(data,1),1) .* data,2);
        err = length(err(err < 0)) / length(err);
    end
end