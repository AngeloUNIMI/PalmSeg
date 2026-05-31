function [rotImage] = compensateCropBB(rotImage, h_orig, w_orig)

[h_rot, w_rot] = size(rotImage);
rotImage = imcrop(rotImage, [(w_rot/2 - w_orig/2), (h_rot/2 - h_orig/2), w_orig, h_orig]);
%resize just to compensate small differences
rotImage = imresize(rotImage, [h_orig, w_orig]);