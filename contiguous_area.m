function result = contiguous_area(image)
    [labels maxValue] = bwlabel(image);
    %maxValue = max(labels(:));
    
    for i = 1:maxValue
       areas(i) = sum(sum(labels == i));
    end
    
    areasOrdered = sort(areas, 'descend');
    
    firstAreaSize = areasOrdered(1);
    
    composition = zeros(size(labels,1),size(labels,2));
    %composition(labels~=correctLabel) = 0;
    
    correctLabel = find(areas == firstAreaSize,1);
    composition(labels==correctLabel) = 255;
    
    j=2;
    while maxValue>j && areasOrdered(j)>firstAreaSize*0.6
        composition(labels==find(areas == areasOrdered(j),1)) = 255;
        j = j+1;
    end
    
    
    result = composition;
end