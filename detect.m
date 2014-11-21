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
photo=imread('data/test/DSC00014_c.JPG');

[H, W, k]=size(photo);
I=double(reshape(rgb2ycbcr(photo), H*W, 3));
Y=reshape(I(:, 1), H, W);
I=I(:, 2:3);
ps=mvnpdf(I, mu, sigma);
P=reshape(ps, H, W);

wh=100;
ww=72;
m=10;
scales=5;
step=10;

nwins=round((W-cww-1)*(H-cwh-1)/step^2);
is=zeros(scales,nwins);
js=zeros(scales,nwins);
dffss=zeros(scales,nwins);
difss=zeros(scales,nwins);
sps=zeros(scales,nwins);


cwh=wh;
cww=ww;
for s=1:scales
    s
    cwh=round(wh*1.25^(s-1));
    cww=round(ww*1.25^(s-1));
    ind=1;
    for j=1:step:(W-cww-1)
        for i=1:step:(H-cwh-1)
            lumi=Y(i:i+cwh-1, j:j+cww-1);
            lumi=imresize(lumi, [wh ww]);
            dffss(s,ind)=dffs(lumi(:), eigenfaces, X_mean, m);
            difss(s,ind)=sqrt(sum((lumi(:)-X_mean).^2));

            skin=P(i:i+cwh-1, j:j+cww-1);
            skin=imresize(skin, [wh ww]);
            sps(s,ind)=mean(skin(:));
            is(s,ind)=i;
            js(s,ind)=j;
            ind=ind+1;
        end
    end
end

spsp=sps/max(max(sps));
dffssp=1-dffss/max(max(dffss));
difssp=1-difss/max(max(difss));

%% plot scale space
figure;
subplot(2,3,1);
imshow(photo);

classif=spsp .* dffssp .* difssp;
classif=classif/max(max(classif));

for i=1:scales
    subplot(2,3,i+1);
    imshow(photo);
    hold on;
    img=scale_output(classif, sps, i, H,W,wh,ww,step);
    phandle=imagesc(img, [0 1]);
    set(phandle, 'AlphaData', 125);
end

%%
classif=spsp .* dffssp .* difssp;
classif=classif/max(max(classif));

% imagesc(scale_output(classif>.3, sps, 1, H,W,wh,ww,step));

classif=classif(1,1:sum(sps(1,:)>0));
bin=classif>.3;
bin=reshape(bin,  ceil((H-wh-1)/step), []);

[class, num]=bwlabel(bin, 8);

rects=zeros(scales*10,4);
j=1;

for j=1:num
    [I, J]=ind2sub(size(bin), find(class==j));
    lt=[min(J)*step, min(I)*step];
    br=[max(J)*step+ww/2+10, max(I)*step+wh/2+10];
    rects(j,:)=[lt, br-lt];
    j=j+1;
end

figure;
imshow(photo);
title('Composed criterion and detected global minimum')
hold on;
imag=scale_output(classif>.3, sps, channel, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag)), [0 1]);
set(phandle, 'AlphaData', 100);


for i=1:j-1
    rectangle('Position', rects(i,:), 'LineWidth',2, 'EdgeColor','b');
end

%%


figure;
subplot(2,3,1);
imshow(photo);
for i=1:scales
    subplot(2,3,i+1)
    
    imshow(photo);
    title('DFFS');
    hold on;
    imag=scale_output(classif, sps, i, H,W,wh,ww,step);
    phandle=imagesc(imag/max(max(imag)), [0 1]);
    set(phandle, 'AlphaData', 125);
end

%% plot results
A=127;

channel=2;

figure;
subplot(2, 2, 1);
imshow(photo);
title('Original image')

subplot(2, 2, 2);
[v, i]=max(spsp);
imshow(photo);
title('Face color probability')
hold on;
imag=scale_output(spsp, sps, channel, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag))*255);
set(phandle, 'AlphaData', A);
% rectangle('Position',[js(channel,i) is(channel,i) 72 100], 'LineWidth',2, 'EdgeColor','b');


subplot(2, 2, 3);
[v, j]=max(dffssp);
imshow(photo);
title('Distance from face space')
hold on;
imag=scale_output(dffssp, dffss, channel, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag))*255);
set(phandle, 'AlphaData', A);
% rectangle('Position',[js(channel,j) is(channel,j) 72 100], 'LineWidth',2, 'EdgeColor','b');

subplot(2, 2, 4);
[v, k]=max(difssp);
imshow(photo);
hold on;
imag=scale_output(difssp, difss, channel, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag))*255);
title('Distance from mean face')
set(phandle, 'AlphaData', A);
% rectangle('Position',[js(channel,k) is(channel,k) 72 100], 'LineWidth',2, 'EdgeColor','b');

%% combination

% classif=spsp(channel,:);
classif=spsp .* dffssp .* difssp;
% classif=difssp(channel,:)
% classif=classif(sps(channel, :)>0);

rects=zeros(scales*10,4);
j=1;

for threshold=.1:-.02:0.09
    for channel=scales:-1:1
        [vals, inds]=sort(classif(channel, :), 2, 'descend');
        for i=1:numel(inds)
            ind=inds(i);
            
            if j>10 || vals(i)<threshold
                break;
            end
            
            rect=[js(channel,ind) is(channel,ind) 72*1.25^(channel-1) 100*1.25^(channel-1)];
            overlaps=rectint(rects, rect);
            if max(overlaps)<(0.1*72*1.25^(channel-1)*100*1.25^(channel-1)) % 10% of area
                fprintf('Scale %d, value %d\n', channel, vals(i));
                rects(j,:)=rect;
                j=j+1;
            end

        end
    end
end

figure;
imshow(photo);
title('Composed criterion and detected faces')
hold on;
imag=scale_output(classif, sps, 1, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag)), [0 1]);
set(phandle, 'AlphaData', 200);


for i=1:j-1
    rectangle('Position', rects(i,:), 'LineWidth',2, 'EdgeColor','b');
end

%% max over whole space
searchspace=zeros(H, W, scales);

space=spsp(channel,:) .* dffssp(channel,:) .* difssp(channel,:);






