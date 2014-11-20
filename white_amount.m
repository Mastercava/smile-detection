function y = white_amount(image)
    gray = rgb2gray(image);
    aperture = gray;
    aperture(gray<45) = 255;
    y = sum(sum(aperture>200));
end
