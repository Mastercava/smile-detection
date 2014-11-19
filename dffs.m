function [ dists ] = dffs(X, eigenfaces, X_mean, m)
%dffs Distance from face space
%
%   X          vectorized images, size [m x n_of_ims]
%   eigenfaces the eigenfaces representing the face space, size [m x m]
%   m          no of eigenfaces to use, scalar

    projection=reconstruct_images(compact_representation(X, eigenfaces, m), eigenfaces, X_mean);
    dists=sqrt(sum((X-projection).^2));
end

