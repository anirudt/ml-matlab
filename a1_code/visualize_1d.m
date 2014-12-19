% X_n is 1-d
% X_train, X_test, t_train, t_test should all be 1-d, and need to be defined as well.
% You should modify y_ev

% Plot a curve showing learned function.
x_ev = (min(X_n):0.1:max(X_n))';

% Put your regression estimate here.
y_ev = rand(size(x_ev));

figure;
% Make the fonts larger, good for reports.
set(gca,'FontSize',15);
plot(x_ev,y_ev,'r.-');  
hold on;
plot(X_train,t_train,'g.');
plot(X_test,t_test,'bo');
hold off;
title(sprintf('Fit with degree %d polynomial',5));
