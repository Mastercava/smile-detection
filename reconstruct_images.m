%
% Z = reconstruct_images(W, Y, X_mean)
%
% Function for reconstruct the approximated version of the vectorized
% images
%
% Input:
%       W - Vectors of weights as the reduced representation, of size [m, number_of_images]
%       Y - Principal components (PC) sorted in decreasing order wrt the eigenvalues,
%           of size [width*height, number_of_images]
%       X_mean - Mean veactorized image, of size [width*height, 1]
% Output:
%       Z - Reconstructed vectorized images, of size [width*height, number_of_images]
%


function Z = reconstruct_images(W, Y, X_mean)
    
    % Get number of components and number of samples
    [m num_samples] = size(W);
    
    % Apply the liner combination and add the mean image
    
	Z=Y(:, 1:m)*W+repmat(X_mean, 1, num_samples);
    
end
