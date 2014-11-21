function coord = thereare2eyes(eb2, sizex, sizey)
  %  colormap(gray(256));
  %  imagesc(eb2);
    
    states = regionprops(eb2);
    lefts = [];
    rights = [] ;
    coord = [0 0 0 0 0];
    eyessize = size(eb2);
    fill=nnz(eb2)/eyessize(1)/eyessize(2);
    
    if (fill<0.2)
    for n=1:size(states)
        area =  states(n).Area;
        xpercent = states(n).BoundingBox(3)/sizex;
        ypercent = states(n).BoundingBox(4)/sizey;
        boxarea = (states(n).BoundingBox(3)*states(n).BoundingBox(4));
        percentarea = area/boxarea;
        
        if ((xpercent<0.25) & (xpercent>0.09) & (ypercent<0.15) & (percentarea>0.2))
           
           xcenter = states(n).Centroid(1);
           ycenter = states(n).Centroid(2);   
          
      %     hold on
      %     plot(xcenter,ycenter,'rx')
       %    hold off
          
           if (xcenter<eyessize(2)/2) 
           lefts = [lefts; xcenter, ycenter];
           else
           rights = [rights; xcenter, ycenter];
           end
       end   
    end
    
    psl=size(lefts);
    psr=size(rights);
    pnl=psl(1);
    pnr=psr(1);
   
    if pnl>0 & pnr>0 
        
        sortval = lefts(:,2); 
        [~,sortorder] = sort(sortval); 
        sorted_lefts = lefts(sortorder,:);
        sortval = rights(:,2); 
        [~,sortorder] = sort(sortval); 
        sorted_rights = rights(sortorder,:);
        if (abs(sorted_lefts(pnl,2)-sorted_rights(pnr,2))/sizey < 0.05)
        coord = [1 sorted_lefts(pnl,1) sorted_lefts(pnl,2) sorted_rights(pnr,1) sorted_rights(pnr,2)];
        end
    end
    end    
        
end