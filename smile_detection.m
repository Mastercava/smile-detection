clear all; clc;

%{
I = a(:,:,1);


%GRAYSCALE THRESHOLD
gray = rgb2gray(a);
aperture = gray;
aperture(gray<45) = 255;
white = sum(sum(aperture>200));
display(white);

figure(1);
imshow(aperture);


%}

a = imread('DSC09992.JPG');
b = imread('DSC09991.JPG');

display(white_amount(a));
display(white_amount(b));

