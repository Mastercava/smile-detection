function result = verify_contiguity(mask, corners)
    originalWidth = size(mask,2);
    
    xcoords = corners(:,1);
    xmax = max(xcoords);
    xmin = min(xcoords);
    pointsWidth = xmax-xmin;
    
    if pointsWidth < round(originalWidth*0.6)
        result = 0;
    else
        result = 1;
    end
end