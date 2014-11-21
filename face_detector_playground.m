%% learn skin color
[mu, sigma]=learn_skincolor(load_images('data/facecolor_img', '*.JPG'), load_images('data/facecolor_label', '*.png'));

%% try skin segmentation
Im=imread('data/facecolor_img/DSC09997.JPG');
[H, W, k]=size(Im);
I=double(reshape(rgb2ycbcr(Im), H*W, 3));
I=I(:, 2:3);
ps=mvnpdf(I, mu, sigma);
imagesc(reshape(ps, 225, 300));

%% load PCA data
trn_ims=load_images('data/eigendata', '*.JPG');
N=length(trn_ims);
[H, W, k]=size(trn_ims{1});
itrn=zeros(H, W, N);
for i=1:N
    itrn(:,:,i)=histeq(rgb2gray(trn_ims{i}));
end

%% learn PCA
[X, X_mean]=prepare_data(itrn);
[eigenfaces, lambdas]=pca_basis(X);

%% detect faces
photo=imread('data/test/DSC00103.JPG');

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

nwins=round((W-ww-1)*(H-wh-1)/step^2);
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

%% plot some criterion in scale space
criterion=spsp; % <--- criterion to plot

figure;
subplot(2,3,1);
imshow(photo);
for i=1:scales
    subplot(2,3,i+1)
    imshow(photo);
    hold on;
    imag=scale_output(criterion, sps, i, H,W,wh,ww,step);
    phandle=imagesc(imag/max(max(imag)), [0 1]);
    set(phandle, 'AlphaData', 125);
end

%% plot combined criterion in scale space
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


%% plot the individual criterions on given scale

channel=1; % the scale
A=127; % alpha of overlay, 1=criterion, 255=photo

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

subplot(2, 2, 3);
[v, j]=max(dffssp);
imshow(photo);
title('Distance from face space')
hold on;
imag=scale_output(dffssp, dffss, channel, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag))*255);
set(phandle, 'AlphaData', A);

subplot(2, 2, 4);
[v, k]=max(difssp);
imshow(photo);
hold on;
imag=scale_output(difssp, difss, channel, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag))*255);
title('Distance from mean face')
set(phandle, 'AlphaData', A);

%% detection results

classif=spsp .* dffssp .* difssp;

rects=zeros(scales*10,4);
j=1;

for threshold=.1:-.02:0.06 % <--- parameters here
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
imag=scale_output(classif, sps, 2, H,W,wh,ww,step);
phandle=imagesc(imag/max(max(imag)), [0 1]);
set(phandle, 'AlphaData', 200);


for i=1:j-1
    rectangle('Position', rects(i,:), 'LineWidth',2, 'EdgeColor','b');
end







