function output = whiteBalanceCorrection(img)
%WHITEBALANCECORRECTION Shades of Gray method - best for underwater.

    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);

    % Shades of Gray (p=6 norm) — more robust than Gray World or White Patch
    p = 6;
    norm_R = mean(R(:).^p)^(1/p);
    norm_G = mean(G(:).^p)^(1/p);
    norm_B = mean(B(:).^p)^(1/p);

    % Target: geometric mean of the three norms
    norm_avg = (norm_R * norm_G * norm_B)^(1/3);

    gain_R = norm_avg / norm_R;
    gain_G = norm_avg / norm_G;
    gain_B = norm_avg / norm_B;

    % Clamp gains to prevent overcorrection
    gain_R = min(gain_R, 1.6);
    gain_G = min(gain_G, 1.6);
    gain_B = min(gain_B, 1.6);

    output = cat(3, R*gain_R, G*gain_G, B*gain_B);
    output = min(max(output, 0), 1);

    fprintf('WB Gains ? R:%.2f  G:%.2f  B:%.2f\n', gain_R, gain_G, gain_B);
end