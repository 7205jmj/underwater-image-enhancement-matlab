function evaluateMetrics(original, enhanced, reference)
%EVALUATEMETRICS Computes image quality metrics.

    fprintf('\n========= Quality Metrics =========\n');

    % Convert to uint8 if needed
    if ismatrix(original) || max(original(:)) <= 1
        orig_u8 = im2uint8(original);
        enh_u8  = im2uint8(enhanced);
        ref_u8  = im2uint8(reference);
    end

    %% 1. PSNR - Peak Signal-to-Noise Ratio (vs reference)
    psnr_orig = psnr(orig_u8, ref_u8);
    psnr_enh  = psnr(enh_u8, ref_u8);
    fprintf('PSNR  | Original: %.2f dB  |  Enhanced: %.2f dB\n', psnr_orig, psnr_enh);

    %% 2. SSIM - Structural Similarity Index (vs reference)
    ssim_orig = ssim(orig_u8, ref_u8);
    ssim_enh  = ssim(enh_u8, ref_u8);
    fprintf('SSIM  | Original: %.4f  |  Enhanced: %.4f\n', ssim_orig, ssim_enh);

    %% 3. MSE - Mean Squared Error
    mse_orig = immse(orig_u8, ref_u8);
    mse_enh  = immse(enh_u8, ref_u8);
    fprintf('MSE   | Original: %.2f  |  Enhanced: %.2f\n', mse_orig, mse_enh);

    %% 4. Entropy (higher = more information content)
    entropy_orig = entropy(rgb2gray(orig_u8));
    entropy_enh  = entropy(rgb2gray(enh_u8));
    fprintf('Entropy | Original: %.4f  |  Enhanced: %.4f\n', entropy_orig, entropy_enh);

    %% 5. UIQM (no-reference score)
    uiqm_orig = computeUIQM(original);
    uiqm_enh  = computeUIQM(enhanced);
    fprintf('UIQM  | Original: %.4f  |  Enhanced: %.4f\n', uiqm_orig, uiqm_enh);

    fprintf('===================================\n');
end