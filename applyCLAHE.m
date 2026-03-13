function output = applyCLAHE(img)
%APPLYCLAHE CLAHE in LAB space with controlled saturation.

    lab = rgb2lab(img);
    L   = lab(:,:,1) / 100;

    L_clahe = adapthisteq(L, ...
        'ClipLimit',    0.008, ...   % ? lower = prevents washed-out look
        'Distribution', 'uniform', ... % ? better for already-bright images
        'NumTiles',     [8 8]);

    lab(:,:,1) = L_clahe * 100;

    % Saturation boost - restore colors lost underwater
    lab(:,:,2) = lab(:,:,2) * 1.20;
    lab(:,:,3) = lab(:,:,3) * 1.20;

    output = lab2rgb(lab);
    output = min(max(output, 0), 1);
    fprintf('CLAHE applied\n');
end