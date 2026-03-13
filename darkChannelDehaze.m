function output = darkChannelDehaze(img)
%DARKCHANNEL Haze removal using the Dark Channel Prior (He et al., 2009).

    % Ensure input is double in [0,1]
    img = double(img);
    if max(img(:)) > 1
        img = img / 255;
    end

    patch_size = 10;
    omega      = 0.60;
    t_min      = 0.25;

    %% Step 1: Dark Channel
    dark_ch = min(img, [], 3);
    dark_ch = imerode(dark_ch, strel('square', patch_size));

    %% Step 2: Atmospheric Light (A) — fixed extraction
    num_pixels  = numel(dark_ch);
    flat_dark   = dark_ch(:);
    [~, sorted_idx] = sort(flat_dark, 'descend');

    % Top 0.1% brightest pixels in dark channel
    top_n       = max(1, round(0.001 * num_pixels));
    top_idx     = sorted_idx(1:top_n);

    % Flatten image to (N x 3), pick candidate rows, find brightest
    [rows, cols, ~] = size(img);
    flat_img    = reshape(img, rows * cols, 3);
    candidates  = flat_img(top_idx, :);               % top_n × 3

    [~, best]   = max(sum(candidates, 2));             % row with max brightness
    A           = candidates(best, :);                 % guaranteed 1×3
    A           = double(A(:)');                       % force row vector 1×3

    fprintf('Atmospheric Light A = [%.4f  %.4f  %.4f]\n', A(1), A(2), A(3));

    %% Step 3: Transmission Map — safe per-channel division
    % Normalise each channel separately to avoid reshape issues
    img_norm = zeros(size(img));
    for c = 1:3
        img_norm(:,:,c) = img(:,:,c) / A(c);
    end

    dark_norm   = min(img_norm, [], 3);
    dark_norm   = imerode(dark_norm, strel('square', patch_size));
    transmission = 1 - omega * dark_norm;

    %% Step 4: Guided Filter — refine transmission
    gray_guide   = rgb2gray(img);
    transmission = imguidedfilter(transmission, gray_guide, ...
        'NeighborhoodSize', 60, 'DegreeOfSmoothing', 1e-3);

    %% Step 5: Recover Scene Radiance — safe per-channel recovery
    t_clamped = max(transmission, t_min);
    output    = zeros(size(img));
    for c = 1:3
        output(:,:,c) = (img(:,:,c) - A(c)) ./ t_clamped + A(c);
    end

    output = min(max(output, 0), 1);
    fprintf('Dehazing complete (omega=%.2f, t_min=%.2f)\n', omega, t_min);
end