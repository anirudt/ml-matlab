function [t,X] = loadData()
% [t,X] = loadData()
%
%
% Read the mpg dataset
% t is an n-by-1 vector of target values, miles per gallon
% X is n-by-d matrix of input variables, each row is one training sample
%
% The mpg dataset comes from the UCI repository, please see:
% http://archive.ics.uci.edu/ml/datasets/Auto+MPG
% for documentation on the dataset, including description of input variables

[A1,A2,A3,A4,A5,A6,A7,A8] = textread('auto-mpg.data','%f%f%f%f%f%f%f%f%*[^\n]');

t = A1;
X = [A2 A3 A4 A5 A6 A7 A8];

% Randomize rows, there is structure in the ordering of the rows in auto-mpg.data.
% Use a fixed random permutation.
% If interested, see what happens with a real random permuation:
% rp = randperm(size(X,1));
load('rp.mat');  % Get the permutation.
X = X(rp,:);
t = t(rp,:);
%save('rp.mat','rp');