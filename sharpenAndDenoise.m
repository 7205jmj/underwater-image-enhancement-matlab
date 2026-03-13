function output = sharpenAndDenoise(img)
%SHARPENANDDENOISE Applies unsharp masking for sharpening, then Wiener filter for denoising.

    %% Sharpening: Unsharp Masking
    % output = img + amount * (img - blurred_img)
    sigma_blur = 1.5;    % Gaussian blur sigma
    amount = 0.6;        % Sharpening strength (0.3-0.8 recommended)
    threshold = 0.03;    % Ignore edges smaller than this (avoids sharpening noise)

    sharpened = imsharpen(img, ...
        'Radius', sigma_blur, ...
        'Amount', amount, ...
        'Threshold', threshold);

    %% Denoising: Wiener Filter (per channel)
    % Wiener filter is optimal for additive Gaussian noise removal
    noise_win = [5 5]; % 5x5 local neighborhood window

    R = wiener2(sharpened(:,:,1), noise_win);
    G = wiener2(sharpened(:,:,2), noise_win);
    B = wiener2(sharpened(:,:,3), noise_win);

    output = cat(3, R, G, B);
    output = min(max(output, 0), 1);

    fprintf('Sharpening (sigma=%.1f, amount=%.1f) + Wiener denoise applied\n', ...
        sigma_blur, amount);
end