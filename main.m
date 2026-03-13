%% Underwater Image Enhancement - Main Script
clc; clear; close all;

%% 1. Load Image
[filename, filepath] = uigetfile({'*.jpg;*.png;*.bmp','Image Files'}, ...
    'Select Underwater Image');
if isequal(filename,0), error('No image selected.'); end
original = im2double(imread(fullfile(filepath, filename)));

%% 2. White Balance
wb_img = whiteBalanceCorrection(original);

%% 3. CLAHE
clahe_img = applyCLAHE(wb_img);

%% 4. Dehaze
dehazed_img = darkChannelDehaze(clahe_img);

%% 5. Sharpen & Denoise
sharp_img = sharpenAndDenoise(dehazed_img);

%% 6. Gamma Correction  ? lower gamma = brighter
gamma_img = gammaCorrect(sharp_img, 0.75);
hsv    = rgb2hsv(gamma_img);
hsv(:,:,2) = min(hsv(:,:,2) * 1.25, 1.0);  % boost saturation 25%
gamma_img  = hsv2rgb(hsv);

final = im2uint8(gamma_img);

%% 7. Final
final = im2uint8(gamma_img);

%% ---- Display all 7 stages in a clean 2x4 grid ----
%% ---- Display each stage in its own window ----

figure('Name','1. Original','NumberTitle','off');
imshow(original); title('1. Original','FontSize',13,'FontWeight','bold');

figure('Name','2. White Balance','NumberTitle','off');
imshow(wb_img); title('2. White Balance','FontSize',13,'FontWeight','bold');

figure('Name','3. CLAHE','NumberTitle','off');
imshow(clahe_img); title('3. CLAHE Contrast Enhancement','FontSize',13,'FontWeight','bold');

figure('Name','4. Dehazed','NumberTitle','off');
imshow(dehazed_img); title('4. Dehazed (Dark Channel Prior)','FontSize',13,'FontWeight','bold');

figure('Name','5. Sharpened','NumberTitle','off');
imshow(sharp_img); title('5. Sharpened & Denoised','FontSize',13,'FontWeight','bold');

figure('Name','6. Gamma Corrected','NumberTitle','off');
imshow(gamma_img); title('6. Gamma Corrected','FontSize',13,'FontWeight','bold');

figure('Name','7. Final Output','NumberTitle','off');
imshow(final); title('7. Final Enhanced Output','FontSize',13,'FontWeight','bold');

figure('Name','Original vs Enhanced','NumberTitle','off');
imshow([im2uint8(original), final]);
title('Original  |  Enhanced','FontSize',13,'FontWeight','bold');
%% Save
imwrite(final, 'enhanced_output.jpg', 'Quality', 95);
fprintf('\nSaved: enhanced_output.jpg\n');

%% Metrics
fprintf('\n--- No-Reference Metrics ---\n');
uiqm_orig = computeUIQM(original);
uiqm_enh  = computeUIQM(gamma_img);
fprintf('UIQM | Original: %.4f  ?  Enhanced: %.4f\n', uiqm_orig, uiqm_enh);
fprintf('Entropy | Original: %.4f  ?  Enhanced: %.4f\n', ...
    entropy(rgb2gray(im2uint8(original))), entropy(rgb2gray(final)));
%% ---- Tile all windows neatly ----
% Works on MATLAB R2016b and later
for f = 1:8
    figure(f);
    set(f, 'Units','normalized');
end

% Auto-arrange in a 2x4 grid pattern
positions = [
    0.00 0.50 0.25 0.45;   % Fig 1 - top left
    0.25 0.50 0.25 0.45;   % Fig 2
    0.50 0.50 0.25 0.45;   % Fig 3
    0.75 0.50 0.25 0.45;   % Fig 4
    0.00 0.02 0.25 0.45;   % Fig 5 - bottom left
    0.25 0.02 0.25 0.45;   % Fig 6
    0.50 0.02 0.25 0.45;   % Fig 7
    0.75 0.02 0.25 0.45;   % Fig 8 - comparison
];

for f = 1:8
    figure(f);
    set(f, 'Units','normalized', 'OuterPosition', positions(f,:));
end%% ---- Tile all windows neatly ----
% Works on MATLAB R2016b and later
for f = 1:8
    figure(f);
    set(f, 'Units','normalized');
end

% Auto-arrange in a 2x4 grid pattern
positions = [
    0.00 0.50 0.25 0.45;   % Fig 1 - top left
    0.25 0.50 0.25 0.45;   % Fig 2
    0.50 0.50 0.25 0.45;   % Fig 3
    0.75 0.50 0.25 0.45;   % Fig 4
    0.00 0.02 0.25 0.45;   % Fig 5 - bottom left
    0.25 0.02 0.25 0.45;   % Fig 6
    0.50 0.02 0.25 0.45;   % Fig 7
    0.75 0.02 0.25 0.45;   % Fig 8 - comparison
];

for f = 1:8
    figure(f);
    set(f, 'Units','normalized', 'OuterPosition', positions(f,:));
end