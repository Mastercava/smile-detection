%
% W = compact_representation(X, Y, m)
%
% Function for computing the reduced representation of the images using the
% m most dominant components
%
% Input:
%       X - Vectorized and centered images, of size [width*height, number_of_images]
%       Y - Principal components (PC) sorted in decreasing order wrt the eigenvalues,
%           of size [width*height, number_of_images]
%       m - Number of components to be used for the approximation, of size [1, 1]
% Output:
%       W - Vectors of weights as the reduced representation, of size [m, number_of_images]
%

function W = compact_representation(X, Y, m)
    
    % Project the images on the PC basis
    
    W=Y(:, 1:m)'*X;
    
end