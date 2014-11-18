%
% [Y lambdas] = pca_basis(X)
%
% Function that computes the orthogonal basis of the principal components
% 
% Input:
%       X - Vectorized and centered images, of size [width*height, number_of_images]
% Output:
%       Y - Principal components (PC) sorted in decreasing order wrt the eigenvalues,
%           of size [width*height, number_of_images]
%       lambdas - Eigenvalores corresponging to the PC (decreasing order), 
%                 of size [width*height, 1]
%

function [Y lambdas] = pca_basis(X)
    
    % Trick for implementation
    
	[V D]=eig(X'*X);
    V=X*V;
        
    % Sorting the eigen vectors and values
    
    [lambdas I]=sort(max(D), 2, 'descend');
    Y=V(:, I);
    
    % Normalize the eigenvectors and eigenvalues

	lambdas=lambdas'./sum(lambdas);
    
    Y=Y./repmat(sqrt(sum(Y.^2, 1)), size(X, 1), 1);
    
end
