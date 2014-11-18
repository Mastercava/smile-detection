function classify = adaboost_classify(strong_class, X)
% classify = adaboost_classify(strong_class, X)
%
% Applies the strong classifier to the data X and returns the
% classification labels
%
%   Parameters:
%       strong_class - the structure returned by adaboost()
%
%       X [K x N] - training samples, K is the number of weak classifiers
%            and N the number of data points
%
%   Returns:
%       classify [1 x N] - the labels of the input data X as predicted by
%            the strong classifier strong_class
%

classes=zeros(1, size(X, 2));


for i=1:numel(strong_class.alpha)
    classes=classes+strong_class.alpha(i)*weak_classify(X, strong_class.wc(i));
end

classify=sign(classes);