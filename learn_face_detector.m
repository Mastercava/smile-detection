%% learn skin color
[mu, sigma]=learn_skincolor(load_images('data/facecolor_img', '*.JPG'), load_images('data/facecolor_label', '*.png'));

%% learn eigenfaces
trn_ims=load_images('data/eigendata', '*.JPG');
N=length(trn_ims);
[H, W, k]=size(trn_ims{1});
itrn=zeros(H, W, N);
for i=1:N
    itrn(:,:,i)=histeq(rgb2gray(trn_ims{i}));
end

[X, X_mean]=prepare_data(itrn);
[eigenfaces, lambdas]=pca_basis(X);

detection_training=struct('mu', mu, 'sigma', sigma, 'eigenfaces', eigenfaces, 'mean_face', X_mean);
save('face_detection_learned_test.mat', 'detection_training');


