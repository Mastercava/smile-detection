%% load data


%% learn skin color
N=7;

mu=zeros(1,2);
sigma=zeros(2);
count=0;

figure;
hold on;

for i=1:N
    [H, W, ~]=size(trn_color_ims{i});
    I=double(reshape(rgb2ycbcr(trn_color_ims{i}), H*W, 3));
    size(I)
    lbls=trn_color_labels{i};
    
    idxs=find(lbls<128);
    size(idxs)
    
    pixels=I(idxs, 2:3);
    size(pixels)
    
    pixels(1:10, :)
    n=size(pixels, 1);
    
    scatter(pixels(:, 1), pixels(:, 2));
    
    count=count+n;
    mu=mu+sum(pixels);
    sigma=sigma+cov(pixels)*(n-1);
end

mu=mu/count;
sigma=sigma/(count-1);

%% try skin segmentation

I=double(reshape(rgb2ycbcr(imread('data/DSC09996.JPG')), H*W, 3));
I=I(:, 2:3);
ps=mvnpdf(I, mu, sigma);
imagesc(reshape(ps, 225, 300));

%% load PCA data
trn_ims=load_images('data/eigendata');
N=length(trn_ims)
[H, W, k]=size(trn_ims{1});
itrn=zeros(H, W, N);
for i=1:N
    itrn(:,:,i)=histeq(rgb2gray(trn_ims{i}));
end

%% learn PCA
[X, X_mean]=prepare_data(itrn);
[eigenfaces, lambdas]=pca_basis(X);
disp_eigenfaces(eigenfaces, [100 72]);


%% detect faces
photo=imread('data/test.png');

[H, W, k]=size(photo);
I=double(reshape(rgb2ycbcr(photo), H*W, 3));
Y=reshape(I(:, 1), H, W);
I=I(:, 2:3);
ps=mvnpdf(I, mu, sigma);
P=reshape(ps, H, W);

wh=100;
ww=72;
is=[];
js=[];
dffss=[];
difss=[];
sps=[];

m=10;
step=2;

for j=1:step:(W-ww-1)
    for i=1:step:(H-wh-1)
        lumi=Y(i:i+wh-1, j:j+ww-1);
        dffss(end+1)=dffs(lumi(:), eigenfaces, X_mean, m);
        difss(end+1)=sqrt(sum((lumi(:)-X_mean).^2));
        
        skin=P(i:i+wh-1, j:j+ww-1);
        sps(end+1)=sum(skin(:));
        is(end+1)=i;
        js(end+1)=j;
    end
end

%% plot results
imag=zeros(H, W);
A=10;

figure;
subplot(2, 2, 1);
imshow(photo);
title('Original image')

subplot(2, 2, 2);
[v, i]=max(sps);
imshow(photo);
title('Face color provbability')
hold on;
spimage=imresize(reshape(sps, round((H-wh)/step), []), [H-wh W-ww], 'nearest');
imag(wh/2:(H-wh/2-1), ww/2:(W-ww/2-1))=spimage;
phandle=imagesc(imag/max(max(imag))*255);
set(phandle, 'AlphaData', A);
rectangle('Position',[js(i) is(i) 72 100], 'LineWidth',2, 'EdgeColor','b');


subplot(2, 2, 3);
[v, j]=min(dffss);
imshow(photo);
title('Distance from face space')
hold on;
spimage=imresize(reshape(dffss, round((H-wh)/step), []), [H-wh W-ww], 'nearest');
imag(wh/2:(H-wh/2-1), ww/2:(W-ww/2-1))=spimage;
phandle=imagesc(imag/max(max(imag))*255);
set(phandle, 'AlphaData', A);
rectangle('Position',[js(j) is(j) 72 100], 'LineWidth',2, 'EdgeColor','b');

subplot(2, 2, 4);
[v, k]=min(difss);
spimage=imresize(reshape(difss, round((H-wh)/step), []), [H-wh W-ww]);
imag(wh/2:(H-wh/2-1), ww/2:(W-ww/2-1))=spimage;
phandle=imagesc(imag/max(max(imag))*255);
title('Distance from mean face')
set(phandle, 'AlphaData', A);
rectangle('Position',[js(k) is(k) 72 100], 'LineWidth',2, 'EdgeColor','b');

%% combination

classif=(sps/max(sps)) .* (dffss/max(dffss)) .* (difss/max(difss));

figure;
[v, i]=max(classif);
imshow(photo);
title('Composed criterion and detected global minimum')
hold on;
spimage=imresize(reshape(sps, round((H-wh)/step), []), [H-wh W-ww], 'nearest');
imag(wh/2:(H-wh/2-1), ww/2:(W-ww/2-1))=spimage;
phandle=imagesc(imag/max(max(imag))*255);
set(phandle, 'AlphaData', 100);
rectangle('Position',[js(i) is(i) 72 100], 'LineWidth',2, 'EdgeColor','b');