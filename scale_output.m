function [ img ] = scale_output(results, unscaled, scale, H, W, wh, ww, step)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

img=zeros(H,W);
cwh=round(wh*1.25^(scale-1));
cww=round(ww*1.25^(scale-1));
spimage=imresize(reshape(results(scale,1:sum(unscaled(scale,:)>0)), ceil((H-cwh-1)/step), []), [H-cwh W-cww], 'nearest');
img(cwh/2:(H-cwh/2-1), cww/2:(W-cww/2-1))=spimage;
end

