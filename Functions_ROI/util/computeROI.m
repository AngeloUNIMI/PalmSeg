function [ROIout, rotPalm, new_c, top1, top2, bottom1, bottom2, errorC] = computeROI(im, bw, zeroIm1, zeroIm2, grad, gradRefined, roisz_x, roisz_y, xOffset, param)

%init
errorC = 0;
ROIout = [];

if gradRefined
    grad = grad + 180;
end %if gradrefined

%final rotate
rotPalm = imrotate(im, -grad, 'bilinear');
rotBw = imrotate(bw, -grad);
rotzeroIm1 = imrotate(zeroIm1, -grad);
rotzeroIm2 = imrotate(zeroIm2, -grad);
%Find Top coordinate in Rotated Image
[top2, top1] = find(rotzeroIm1 == 255);
%Find Bottom coordinate in Rotated Image
[bottom2, bottom1] = find(rotzeroIm2 == 255);
%compute center position
new_c = computeCenterROI(top1, top2, bottom1, bottom2, xOffset);

%compute ranges
[minRangeX, maxRangeX, minRangeY, maxRangeY] = computeRangesROI(new_c, roisz_x, roisz_y);

%CHECK 7: check indexes
if checkIndexesROI(minRangeX, maxRangeX, minRangeY, maxRangeY, rotBw)
    ROIout = rotPalm(minRangeY : maxRangeY, minRangeX : maxRangeX, :);
else %if checkIndexesROI
    errorC = -1;
    return;
end %if checkIndexesROI

bWROIOut = rotBw(minRangeY : maxRangeY, minRangeX : maxRangeX);
%CHECK 8: majority of pixels is still black
if exist('bWROIOut', 'var') == 1
    percBlack = numel(find(bWROIOut==0)) / numel(bWROIOut);
    if percBlack > param.ROIsize.percBlackPixels
        errorC = -1;
        return;
    end %if numBlack
end %if exist
