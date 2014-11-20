function I = findmouth(im_face, file_name)

SHOW_FINDMOUTH = true;

%% 9-1 Turn original image into color map Cr, Cb
ycbcrmap = rgb2ycbcr(im_face);

y = double(ycbcrmap(:,:,1));
cb = double(ycbcrmap(:,:,2));
cr = double(ycbcrmap(:,:,3));

nx = size(cb,1);
ny = size(cb,2);
n = nx*ny;

%% 9-2, 9-3 NORMALIZE cr./cb and cr.^2 to [0,255]
A = normalize_var(cr./cb,0,255);
B = normalize_var(cr.^2,0,255);

%% 9-4 find mouth map
eta=0.95 * (((1/n)*sum(B)) / ((1/n)*sum(A)));
mmap = (B-eta.*A).^2.*B;
mmap_norm = normalize_var(mmap,0,255);



%% 9-5 line erosion
SE_line = strel('line', size(mmap_norm,1)/20, 0);
%SE_disk = strel('disk', 10);

%Erode = imclose(mmap_norm,SE);
Erode = imerode(mmap_norm,SE_line);


%% 9-6 binary mouth map
%threshold = mean([max(Erode(:)) min(Erode(:))]);
%threshold = ( max(Erode(:)) + 2*min(Erode(:)))/3;
threshold = ( max(Erode(:)) + 3*min(Erode(:)))/4;
%threshold = ( max(Erode(:)) + 7*min(Erode(:)))/8;

binaryErode = Erode>threshold;


%% 9-7 cover upper half of the picture
blockIm = [binaryErode(1:floor(size(binaryErode,1)/2),:)*0;binaryErode(ceil(size(binaryErode,1)/2):end,:)];


%% 9-8 Choose the largest white area in the binary map 
CC = bwconncomp(blockIm);
numPixels = cellfun(@numel, CC.PixelIdxList);
[biggestSize, idx] = max(numPixels);
binaryErode2 = false(size(blockIm));
binaryErode2(CC.PixelIdxList{idx}) = true;
s = regionprops(binaryErode2, 'BoundingBox');
%imcrop(binaryErode2, s.BoundingBox);


%% 9-9 Extract the mouth image
% Get all rows and columns where the image is nonzero
[nonZeroRows, nonZeroColumns] = find(binaryErode2);
% Get the cropping parameters
topRow = min(nonZeroRows(:));
bottomRow = max(nonZeroRows(:));
leftColumn = min(nonZeroColumns(:));
rightColumn = max(nonZeroColumns(:));
length = abs(topRow-bottomRow);
width = abs(rightColumn-leftColumn);

ratioV1 = 0.5;% ratio of the top vertical length of the window
ratioV2 = 2;% ratio of the bottom vertical length of the window
ratioH = 1.2;%ratio of the horizontal length of the window
[m, n] = size(im_face(:,:,1));
if  (topRow + (topRow-bottomRow)/ratioV1 ) > m 
    top = m-1;
else 
    top = topRow + (topRow-bottomRow)/ratioV1;
end

if (bottomRow - (topRow-bottomRow)/ratioV2) < 0
    bottom = 1;
else
    bottom = bottomRow - (topRow-bottomRow)/ratioV2;
end

if (rightColumn + (rightColumn-leftColumn)/ratioH) > n
    right = n-1;
else
    right = rightColumn + (rightColumn-leftColumn)/ratioH;
end

if ( leftColumn - (rightColumn-leftColumn)/ratioH ) < 0
    left = 1;
else
    left = leftColumn - (rightColumn-leftColumn)/ratioH;
end


% Extract a cropped image from the original.
if(top<=m && top>=0 && bottom<=m && bottom>=0 && left <= n && left >= 0 && right <= n && right >= 0)
    croppedImage = im_face(top:bottom, left:right, :);
    I = croppedImage;

else
    I = [];
    str1 = ['ERROR!! Failed to find mouth in ' file_name '!!'];
    sprintf(str1)
end

%% Plot the find mouth process
if(SHOW_FINDMOUTH)
figure
subplot(3,3,1)
imshow(im_face);
title('original')

subplot(3,3,2)
plotim(A);
title('cr/cb')

subplot(3,3,3)
plotim(B);
title('cr^2')

subplot(3,3,4)
plotim(mmap_norm);
title('mouth map')

subplot(3,3,5)
plotim(Erode);
title('mouth map after line erosion')

subplot(3,3,6)
plotim(binaryErode);
title('binary mouth map')

subplot(3,3,7)
plotim(blockIm);
title('blocked upper part of binary mouth map')

subplot(3,3,8)
plotim(binaryErode2);
title('choose largest area')

subplot(3,3,9)
imshow(croppedImage);
title('Cropped mouth Image');
end