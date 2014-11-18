function [imcell]=load_images(directory)

D = dir(strcat(directory, '/*.JPG'));
imcell = cell(1,numel(D));
for i = 1:numel(D)
  imcell{i} = imread(strcat(directory, '/',D(i).name));
end

end