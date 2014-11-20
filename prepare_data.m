% 
% [X X_mean] = prepare_data(images)
% 
% Function for vectorize the stack of images, compute the mean image and
% substract it from the set of images
%
% Input:
%       images - Stack of images, of size [width, height, number_of_images]
% Output:
%       X - Vectorized and centered images, of size [width*height, number_of_images]
%       X_mean - Mean veactorized image, of size [width*height, 1]
%

function [X X_mean] = prepare_data(images)

    % Vectorize images
    X = double(reshape(images, size(images,1)*size(images,2),[]));
    
    % Compute mean vector
    X_mean = mean(X,2);
    
    % Substract mean
    X = X - repmat(X_mean, [1,size(X,2)]);

end