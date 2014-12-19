[t,X] = loadData();
X_n = normalizeData(X);
t = normalizeData(t);
min = 10000000
Xtest = X_n(1:100,:);

% Now, polynomial regression, taking each of the variables separately 
% and conducting a search b/w 1 and degree 10.
i = 1
for i=1:7
    for j=1:10
        [p,S,u] = polyfit(X_n(:,i),t,j);
        [y_est,delta] = polyval(p,X_n(:,i),S);
        if delta<min
            min = delta;
            minp = p;
            mini = i;
            minj = j;
        end
    end
end
minp
mini
minj
t_est = polyval(minp, X_n(:,mini),minj);
plot(t_est, t);
norm(t-t_est)/392

% Now, we implement regularization. We assume a poly of degree eight 
% and loop for the attribute and lambda [regularization parameter].

lambda = [0,0.01,0.1,1,10,100,1000];
min = 1000000

for i=1:7
    for j=1:7
        [p,S,u] = polyfit(X_n(:,i),t,8);
        [y_est,delta] = polyval(p,X_n(:,i),S);
        delta = delta + lambda(j)*norm(X_n(:,i))^2;
        if delta<min
            min=delta;
            minl=lambda(j);
            mini=i;
        end
    end
end
mini
minl
t_est=polyval(minp,X_n(:,mini),8);
norm(t-t_est)/392

    
