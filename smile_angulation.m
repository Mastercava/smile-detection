function result = smile_angulation(points)
    left = points(1,:);
    low = points(2,:);
    right = points(3,:);
    
    leftAngle = atand((low(2)-left(2))/(low(1)-left(1)));
    rightAngle = atand((low(2)-right(2))/(right(1)-low(1)));
    
    result = max(leftAngle, rightAngle);
end