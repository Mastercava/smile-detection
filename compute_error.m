function errors = compute_error(strong_class, X, y)
% errors = compute_error(strong_class, X, y)
%
% Computes the error on data X for *all lengths* of the given strong
% classifier
%
%   Parameters:
%       strong_class - the structure returned by adaboost()
%
%       X [K x N] - samples, K is the number of weak classifiers and N the
%            number of data points
%
%       y [1 x N] - sample labels (-1 or 1)
%
%   Returns:
%       errors [1 x T] - error of the strong classifier for all lenghts 1:T
%            of the strong classifier
%

N=size(X, 2);
T=numel(strong_class.alpha);

classes=zeros(1, N);
errors=zeros(1, T);

for i=1:T
    classes=classes+strong_class.alpha(i)*weak_classify(X, strong_class.wc(i));
    
    errors(i)=sum(sign(classes)~=y)/N;
    
    %keyboard
end
