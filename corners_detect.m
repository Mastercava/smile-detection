function result = corners_detect(corners)
    xcoords = corners(:,1);
    ycoords = corners(:,2);
    
    xmax = max(xcoords);
    xmin = min(xcoords);
    ymax = max(ycoords);
    ymin = min(ycoords);
    width = xmax-xmin;
    height = ymax-ymin;
    middle = round(width/2);
    
    %CORNER DETECTION
    xlow = -1;
    ylow = -1;
    xleft = -1;
    yleft = -1;
    xright = -1;
    yright = -1;
    
    tempLower = 0;
    tempLeft = 0;
    tempRight = 0;
    
    leftLimit1 = xmin;
    rightLimit1 = xmin + round(width/7);
    
    leftLimit2 = xmin + round(width/5*2);
    rightLimit2 = xmax - round(width/5*2);
    
    leftLimit3 = xmax - round(width/7);
    rightLimit3 = xmax;
    
    for i=1:size(xcoords) 
        
        %LEFT CORNER
        if xcoords(i)>=leftLimit1 && xcoords(i)<=rightLimit1
           if tempLeft==0 || ycoords(i)<tempLeft
               xleft = xcoords(i);
               yleft = ycoords(i);
               tempLeft = ycoords(i);
            end
        end
        
        %LOWER CORNER
        if xcoords(i)>=leftLimit2 && xcoords(i)<=rightLimit2
           if tempLower==0 || ycoords(i)>tempLower
               xlow = xcoords(i);
               ylow = ycoords(i);
               tempLower = ycoords(i);
            end
        end
        
        %RIGHT CORNER
        if xcoords(i)>=leftLimit3 && xcoords(i)<=rightLimit3
           if tempRight==0 || ycoords(i)<tempRight
               xright = xcoords(i);
               yright = ycoords(i);
               tempRight = ycoords(i);
            end
        end
        
    end
    
    low = [xlow ylow];
    left = [xleft,yleft];
    right = [xright,yright];
    
    points = [left; low; right];
    result = points;
end