function [ faces ] = face_recognition(photo, params)
%UNTITLED2 detect faces in image
%   image     color image
%   params    learned params, struct with fields:
%               mu, sigma:  learned face color distribution
%               mean_face:     mean face
%               eigenfaces: the eigenfaces

%% scan the photo
[H, W, k]=size(photo);
I=double(reshape(rgb2ycbcr(photo), H*W, 3));
Y=reshape(I(:, 1), H, W);
I=I(:, 2:3);
ps=mvnpdf(I, params.mu, params.sigma);
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

for s=1:scales
    fprintf('Searching on scale %d\n', s);
    cwh=round(wh*1.25^(s-1));
    cww=round(ww*1.25^(s-1));
    ind=1;
    for j=1:step:(W-cww-1)
        for i=1:step:(H-cwh-1)
            lumi=Y(i:i+cwh-1, j:j+cww-1);
            lumi=imresize(lumi, [wh ww]);
            dffss(s,ind)=dffs(lumi(:), params.eigenfaces, params.mean_face, m);
            difss(s,ind)=sqrt(sum((lumi(:)-params.mean_face).^2));

            skin=P(i:i+cwh-1, j:j+cww-1);
            skin=imresize(skin, [wh ww]);
            sps(s,ind)=mean(skin(:));
            is(s,ind)=i;
            js(s,ind)=j;
            ind=ind+1;
        end
    end
end

%% normalize the results
spsp=sps/max(max(sps));
dffssp=1-dffss/max(max(dffss));
difssp=1-difss/max(max(difss));

%% find the faces

classif=spsp .* dffssp .* difssp;

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
%                 fprintf('Scale %d, value %d\n', channel, vals(i));
                rects(j,:)=rect;
                j=j+1;
            end

        end
    end
end

%% output images
faces=cell(1,j-1);
for i=1:j-1
    rect=rects(i,:);
    faces{i}=photo(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :);
end

end

