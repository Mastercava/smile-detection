function [ mu, sigma ] = learn_skincolor( images, labels )
%LEARN_SKINCOLOR Learn skin color distribution from labeled images
%   images      cell array of images
%   labels      cell array of the corresponding labels. Labels are
%               graylevel images, value<128 means skin.
mu=zeros(1,2);
sigma=zeros(2);
count=0;

for i=1:length(images)
    [H, W, ~]=size(images{i});
    I=double(reshape(rgb2ycbcr(images{i}), H*W, 3));
    lbls=labels{i};
    
    idxs=find(lbls<128);
    pixels=I(idxs, 2:3);
    n=size(pixels, 1);
    
    count=count+n;
    mu=mu+sum(pixels);
    sigma=sigma+cov(pixels)*(n-1);
end

mu=mu/count;
sigma=sigma/(count-1);

end

