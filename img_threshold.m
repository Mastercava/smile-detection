function y = img_threshold(image, threshold)
    channel = image(:,:,1);
    mask = channel;
    mask(channel<threshold) = 255;
    mask(channel>=threshold) = 0;
    y = mask;
end