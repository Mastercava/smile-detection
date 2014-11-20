function result = get_smile_aperture(image)

    red = image(:,:,1);
    rows = size(red,1);
    cols = size(red,2);

    middle = round(cols / 2);
    vertical = red(:,middle);
    
    threshold = 100;

    i=1;
    while(i<=rows && vertical(i)>threshold)
       i = i+1;
    end

    line = 0;
    while(i<=rows && vertical(i)<=threshold)
       i = i+1;
       line = line+1;
    end
    
    %UNCOMMENT TO PLOT
    %plot(vertical);
    
    result = normalize_value(line,0,rows);
end