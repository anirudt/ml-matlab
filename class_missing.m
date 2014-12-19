rng(5);
load ionosphere;
labels = unique(Y);

cv = cvpartition(Y, 'holdout', 0.3);
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));
Xtest = X(test(cv),:);
Ytest = Y(test(cv));

%Using bagged trees for now

md11 = ClassificationTree.template('NVarToSample','all' );
RF1 = fitensemble(Xtrain, Ytrain, 'Bag', 150, md11, 'type','classification');

% Use surrogate splits when you encounter missing data

mdl2 = ClassificationTree.template('NVarToSample','all','surrogate','on');
RF2 = fitensemble(Xtrain,Ytrain,'Bag',150,mdl2,'type','classification');

Xtest(rand(size(Xtest))>0.5) = NaN;

ypred1 = predict(RF1,Xtest);
confmat1 = confusionmat(Ytest, ypred1)

ypred2 = predict(RF2, Xtest);
confmat2 = confusionmat(Ytest, ypred2)

