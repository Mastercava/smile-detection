function result = get_smile_factor(image)
    %display([get_smile_angle(image) get_smile_aperture(image) get_smile_white_amount(image) get_smile_teeth(image)]);
    result = get_smile_angle(image) * 3 + get_smile_aperture(image) + get_smile_white_amount(image) + get_smile_teeth(image) * 3;
end