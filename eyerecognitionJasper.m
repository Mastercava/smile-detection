clear all
close all
clc
path('tpmatlab/common',path)
%% Eye recognition

im_face = imread('photos/face/DSC09997.JPG');
ycbcrmap = rgb2ycbcr(im_face);


y = double(ycbcrmap(:,:,1));
cb = double(ycbcrmap(:,:,2));
cr = double(ycbcrmap(:,:,3));

nx = size(cb,1);
ny = size(cb,2);
n = nx*ny;

% NORMALIZE cr./cb and cr.^2 to [0,255]
A = normalize_var(cr./cb,0,255);
B = normalize_var(cr.^2,0,255);
C = normalize_var(cb.^2,0,255);
D = normalize_var((255-cr).^2,0,255);

emapc = (1/3)*(C+D+A);
emapc_norm = normalize_var(emapc,0,255);

if nx>100 && ny>100
    nelr = ceil((nx+ny)/200)+1;
end

se = strel('ball',nelr,nelr^2);

hsv = rgb2hsv(im_face);
luma = hsv(:,:,2);
emapl = imdilate(luma,se)./(imerode(luma,se) + 1);
emapl_norm = normalize_var(emapl,0,255);

emap = emapc_norm .* emapl_norm;

emap_norm = normalize_var(imdilate(emap,se),0,255);

figure
subplot(1,4,1)
imshow(im_face);
title('original')

subplot(1,4,2)
plotim(emapc_norm);
title('EyeMap C')

subplot(1,4,3)
plotim(emapl_norm);
title('EyeMap L')

subplot(1,4,4)
plotim(emap_norm);
title('Eye Map (does not work yet)')

