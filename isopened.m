function resp = isopened(name, xl, yl, xr ,yr)
 %   
    resp=0;
    face = imread(name);
    
    [sizex sizey size3] = size(face);
    grayface = rgb2gray(face);
 %   image(grayface);
    ceneye = imcrop ( grayface, [xl-0.06*sizex yl-sizey*0.033 0.12*sizex sizey*0.07]);
    maxi = max(ceneye(:));
    mini = min(ceneye(:));
    
    if maxi>6*mini
        resp=resp+0.5;
    end   
    figure(2);
    colormap(gray(256));
    imagesc(ceneye);    
    
    ceneye = imcrop ( grayface, [xr-0.06*sizex yr-2 0.12*sizex 6]);    
    maxi = max(ceneye(:));
    mini = min(ceneye(:));
   
    if maxi>6*mini
        resp=resp+0.5;
    end
    
end