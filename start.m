%% Detect smiling people
% TPT01 Image Processing
% Group 3
%

%% Clear all variables and close all open windows
clear all
close all
clc

load 'face_detection_learned.mat';

[filename, pathname, filterindex] = uigetfile( ...
  {'*.jpg;*.tif;*.png;*.gif','All Image Files'
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');

%% Run
figure;
nsel = size(filename,2);    % Number of selected files
total_score = zeros(1,nsel);
for i = 1:nsel
    Im_str = strcat(pathname, filename{i});  % Make filepath/filename string
    Im = imread(Im_str);                % Load the image
    subplot(1,nsel,i);
    imshow(Im);
    
    % Phase 1: Face recognition
    face_array = face_recognition(Im, detection_training);  % Determine all faces from group picture
    nfaces = size(face_array,2);        % Number of faces to be processed
    smiling_factors = zeros(1,nfaces);  % Pre-allocate vector
    eye_factors = zeros(1,nfaces);      % Pre-allocate vector
    
    for j = 1:nfaces
        Im_face = face_array{j};
        % Phase 2: Eye recognition
        [eye_openbool] = eye_recognition(Im_face);  % Determine eyes from face picture
        eye_factors(j) = eye_openbool;                      % Save eye_openbool in array for all faces

        % Phase 3: Mouth recognition
        %function I = findmouth(im_face, file_name)
        Im_mouth = findmouth(Im_face, 'file');              % Determine mouth position from face picture


        % Phase 4: Smile detection
        %function result = get_smile_factor(image)
        smiling_factors(j) = get_smile_factor(Im_mouth);    % Determine smile amount

    end

    total_score(i) = sum(eye_factors + smiling_factors)/nfaces;
    title(sprintf('%s: %.4f', filename{i},total_score(i)));
    
    fprintf('Smiling score: %d\n', total_score(i))
    %pause
end

[~,index] = max(total_score); % Select best image
fprintf('Best smiling score: %d\n', total_score(index))

Im_str = strcat(pathname, filename{index}); % Make best photo filepath/filename string
Im = imread(Im_str);                        % Load the best image
figure;
imshow(Im);
title(sprintf('Best image, scode %.4f', total_score(index)));

