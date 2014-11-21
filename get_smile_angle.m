function result = get_smile_angle(image) 

    %THRESHOLD ONE ONE CHANNEL
    mask = img_threshold(image,75);

    %CONSIDER ONLY CONTIGUOUS AREAS
    contiguousArea = contiguous_area(mask);

    %IDENTIFY INTERESTING POINTS
    corners = corner(contiguousArea,'MinimumEigenvalue');
    
    %PROBLEMS IDENTIFYING CONTIGUITY
    if (verify_contiguity(contiguousArea, corners)==0)
        contiguousArea = mask;
        corners = corner(contiguousArea,'MinimumEigenvalue');
    end
    
    %IDENTIFY CORNERS OF MOUTH
    points = corners_detect(corners);

    %CALCULATE MAXIMUM ANGLE
    angle = smile_angulation(points);
    
    %UNCOMMENT TO PLOT
%     figure;
%     plot_result(contiguousArea,corners,points);
    
    %RETURN RESULT
    result = normalize_value(angle,0,60);

end