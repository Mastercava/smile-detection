
mem1 = imread('mem1.jpg');
mem2 = imread('mem2.jpg');


%eyesdetect(mem3, 5);
for i = [25 ] %8 16 23 1]
    str = ['face/' num2str(i) '.JPG'];
  
   coord = eyesdetect(str);
   answer= eyesareopened(str, coord(2), coord(3),coord(4),coord(5));
   answer
end

%face = imcrop (mem, [350 200 290 370])



