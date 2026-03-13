function output = gammaCorrect(img, gamma)
%GAMMACORRECT Applies power-law gamma correction.
% gamma < 1 ? brightens image (typical for dark underwater scenes)
% gamma > 1 ? darkens image

    if nargin < 2
        gamma = 0.8; % Default: slight brightening
    end

    output = img .^ gamma;
    output = min(max(output, 0), 1);

    fprintf('Gamma correction applied (gamma=%.2f)\n', gamma);
end