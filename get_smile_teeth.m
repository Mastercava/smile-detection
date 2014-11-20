function result = get_smile_teeth(image) 
    
    threshold = 40;
    rows = size(image,1);
    columns = size(image,2);
    
    minx = round(columns/7*2);
    maxx = columns - round(columns/7*2);
    miny = round(rows/7*3);
    maxy = rows - round(rows/7*3);
    
    crop = image(miny:maxy, minx:maxx, :);
    
    crop(:,:,1) = 0; 

    %UNCOMMENT TO PLOT
    %gray = rgb2gray(crop);    
    %imshow(gray);
    
    average = mean2(crop);
    
    if average<20
        average = 0;
    end
    
    result = normalize_value(average, 0, 200);
end