[t,X] = loadData();
X_n = normalizeData(X);
t = normalizeData(t);
min = 10000000
Xtest = X_n(1:100,:);
p = X_n;
u = zeros(1,7);

%Following is the Gaussian basis function for linear regression.
for i=1:7
    u(i) = X_n(randsample(392,1),i);
    p(:,i) = exp(dist2(X_n(:,i),u(i))/8);
end

ptest = p(1:100,:);
t_test = t(1:100);
beta = mvregress(ptest,t_test);

t_est = beta'*X_n';
t_est=t_est';
norm(t_est-t)/392