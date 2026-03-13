function uiqm = computeUIQM(img)
%COMPUTEUIQM Computes the Underwater Image Quality Measure (UIQM).
% UIQM = c1*UICM + c2*UISM + c3*UIConM
% Panetta et al. 2016 - higher is better.

    c1 = 0.0282; c2 = 0.2953; c3 = 3.5753; % Standard weights

    %% UICM: Underwater Image Colorfulness Measure
    R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
    RG = R - G; YB = (R + G)/2 - B;

    mu_RG = mean(RG(:)); sigma_RG = std(RG(:));
    mu_YB = mean(YB(:)); sigma_YB = std(YB(:));

    UICM = -0.0268 * sqrt(mu_RG^2 + mu_YB^2) + ...
            0.1586 * sqrt(sigma_RG^2 + sigma_YB^2);

    %% UISM: Underwater Image Sharpness Measure
    gray = rgb2gray(img);
    sobelH = fspecial('sobel');
    edgeH = imfilter(gray, sobelH, 'replicate');
    edgeV = imfilter(gray, sobelH', 'replicate');
    edge_mag = sqrt(edgeH.^2 + edgeV.^2);
    UISM = mean(edge_mag(:));

    %% UIConM: Underwater Image Contrast Measure
    % Using Michelson contrast in local patches
    blk = 5;
    [rows, cols] = size(gray);
    contrast_vals = [];
    for r = 1:blk:rows-blk
        for c = 1:blk:cols-blk
            patch = gray(r:r+blk-1, c:c+blk-1);
            I_max = max(patch(:));
            I_min = min(patch(:));
            if (I_max + I_min) > 0
                contrast_vals(end+1) = (I_max - I_min) / (I_max + I_min);
            end
        end
    end
    UIConM = mean(contrast_vals);

    uiqm = c1*UICM + c2*UISM + c3*UIConM;
end