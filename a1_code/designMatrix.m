function Phi = designMatrix(X,basis,varargin)
% Phi = designMatrix(X,basis)
% Phi = designMatrix(X,'polynomial',degree)
% Phi = designMatrix(X,'gaussian',Mu,s)
%
% Compute the design matrix for input data X
% X is n-by-d
% Mu is k-by-d
%
% TO DO:: You need to fill in foo1 and foo2

if strcmp(basis,'polynomial')
  k = varargin{1};
  Phi = foo1(X,k);
elseif strcmp(basis,'gaussian')
  Mu = varargin{1};
  s = varargin{2};
  Phi = foo2(X,Mu,s);
else
  error('Unknown basis type');
end
