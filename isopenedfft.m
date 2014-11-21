function resp = isopenedfft(face, x, y)
 %   
    resp=0;
    
    [sizex sizey size3] = size(face);
    grayface = rgb2gray(face);
 %   image(grayface);
    ceneye = imcrop ( grayface, [x-0.06*sizex y-sizey*0.033 0.12*sizex sizey*0.07]);
    maxi = max(ceneye(:));
    mini = min(ceneye(:));
  %  figure(3);
  %  colormap(gray(256));
    modfft=abs(fftshift(fft2(ceneye)))/2;
 %   image(modfft);
    
    meanfft=mean2(modfft);
    sizemodfft = size(modfft);
    ffthor=imcrop ( modfft, [1 sizemodfft(1)/2-1 sizemodfft(2) 3]);
    fftver=imcrop ( modfft, [sizemodfft(2)/2-1 1 3 sizemodfft(1)]);
 %   figure(100);
 %   colormap(gray(256));
 %   image(ffthor);
 %   figure(101);
 %   colormap(gray(256));
 %   image(fftver);
    meanmiddle = mean2(ffthor(:))+mean2(fftver(:));
    meanmiddle/2;
    meanfft;
    ratiofft = meanmiddle/meanfft/2;
    
    if ratiofft<6
        resp=1;
    end    
end