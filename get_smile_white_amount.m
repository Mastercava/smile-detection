function result = get_smile_white_amount(image)
    img = img_threshold(image,45);
    white = sum(sum(img>200));
    result = normalize_value(white,0,size(image,1)*size(image,2));
end
