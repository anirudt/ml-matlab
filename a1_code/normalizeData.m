function X_n = normalizeData(X)
% X_n = normalizeData(X)
%
% Normalize each component of X to have mean 0 and covariance 1.
% X is N-by-D
% X_n is N-by-D
% N datapoints in D-dim space
N = size(X,1);

mu = mean(X,1);
sig = std(X,0,1);

X_n = (X - repmat(mu,[N 1]))./repmat(sig,[N 1]);



