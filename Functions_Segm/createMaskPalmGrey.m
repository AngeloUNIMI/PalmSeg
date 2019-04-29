function [BW, maskedRGBImage] = createMaskPalmGrey(RGB, param)


t = RGB(:,:,1) - RGB(:,:,2);
BW = t > 20;

% imshow(t,[]),
% pause

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;