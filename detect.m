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

%% learn PCA
[X, X_mean]=prepare_data(trn_data.images);
[Y, lambdas]=pca_basis(X);

