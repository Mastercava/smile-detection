
function coord = eyesdetect(myimage)
    N=255;
  %  colormap(gray(256));
    
    face = myimage;
    [sizex sizey size3] = size(face);
    grayface = rgb2gray(face);
    middleface = imcrop ( grayface, [0.05*sizex 0.05*sizey 0.9*sizex 0.9*sizey]);
    eyes = imcrop ( grayface, [0.05*sizex 0.15*sizey 0.95*sizex 0.35*sizey]);
    mean = mean2(eyes);
    
    coeff=1;
    thresh = mean/N/coeff;
    eyesbin = im2bw (eyes, thresh);
    eb2=1-eyesbin;
    eb2 = bwareaopen(eb2, 30);
    nnzz= nnz(eb2);
    eyessize = size(eb2);
    eyessize(1)*eyessize(2);
  %  figure(1);
  %  imagesc(eb2);
    answer = thereare2eyes(eb2,sizex, sizey);
    timetostop = answer(1);
    
    lefts = [];
    rights = [];
    for i=1:25
        coeff=coeff+0.3;
        thresh = mean/N/coeff;
        eyesbin = im2bw (eyes, thresh);
        eb2=1-eyesbin;
        eb2 = bwareaopen(eb2, 30);
     %   colormap(gray(256));
     %    figure(i);
     %       imagesc(eb2);
            
        answer = thereare2eyes(eb2,sizex, sizey);
 %       timetostop = answer(1);
        if (answer(1)==1)
           
            if answer(2)<answer(4)
                lefts=[lefts; answer(2) answer(3)];
                rights=[rights; answer(4) answer(5)];
            end
            if answer(2)>answer(4)
                lefts=[lefts; answer(4) answer(5)];
                rights=[rights; answer(2) answer(3)];
            end
    %        hold on
   %         plot(answer(2),answer(3),'rx');
  %          plot(answer(4),answer(5),'rx');
   %         hold off
        end
        
    end
    
    coord = [0 0 0 0 0 0];
    if size(lefts)>0 & size (rights>0)
    
     sortval = lefts(:,2); 
     [~,sortorder] = sort(sortval); 
     sorted_lefts = lefts(sortorder,:);
     
     
     sortval = rights(:,2); 
     [~,sortorder] = sort(sortval); 
     sorted_rights = rights(sortorder,:);
     
     es=size(lefts);
     en=es(1);
     en
     
     
     
     xl=mean2(lefts(:,1));
     yl=mean2(lefts(:,2));
     xr=mean2(rights(:,1));
     yr=mean2(rights(:,2));
     
     xl=sorted_lefts(en,1);
     yl=sorted_lefts(en,2);
     xr=sorted_rights(en,1);
     yr=sorted_rights(en,2);
%     hold on
%     plot (xl, yl, 'rx');
%     plot(xr, yr, 'rx');
%     hold off
     
     xglobl=xl+0.05*sizex;
     yglobl=yl+0.15*sizey;
     xglobr=xr+0.05*sizex;
     yglobr=yr+0.15*sizey;
    
     coord  = [1 xglobl yglobl xglobr yglobr 0];
         
    end
    
    
    
  
    
   
