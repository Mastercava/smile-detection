%
% disp_eigenfaces(Y, im_size)
%
% Function for displaying the first 10 eigenfaces
%
% Input:
%       Y - Principal components (eigenfaces), of size [width*height, number_of_images]
%       im_size - Size of the image, of size [1, 2] height and width
%

function disp_eigenfaces(Y, im_size)
    
    figure;
    % For the first 10 most dominant eigenfaces
    for i = 1:10
        subplot(2,5,i), imagesc(reshape(Y(:,i), im_size));
        axis('image');
        colormap gray;        
    end
    
end