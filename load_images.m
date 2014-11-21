function [imcell]=load_images(directory, files)
%LOAD_IMAGES load all matching images in a directory into a cell array
%   directory       directory to scan, example 'data/test'
%   files           files to take, example '*.jpg'

D = dir(strcat(directory, '/', files));
imcell = cell(1,numel(D));
for i = 1:numel(D)
  imcell{i} = imread(strcat(directory, '/',D(i).name));
end

end