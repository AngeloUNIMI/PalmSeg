function gradRefined = refineGrad(im, bw, zeroIm1, zeroIm2, grad, roisz_x, roisz_y, xOffset, param)

%init
gradRefined = false;

%rotate
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

%CHECK 1: check indices
if checkIndexesROI(minRangeX, maxRangeX, minRangeY, maxRangeY, rotBw) == 0
    %ranges are off boundaries
    %must add 180 to the orientation
    gradRefined = true;
    return;
end %if new_c

%CHECK 2: check that roi is on correct size
bWROIOut = rotBw(minRangeY : maxRangeY, minRangeX : maxRangeX);
%count black and white pixels
percBlack = numel(find(bWROIOut==0)) / numel(bWROIOut);
%numWhite = numel(find(bWROIOut));
%black pixels no more than 20%
if percBlack > param.ROIsize.percBlackPixels
    %abbiamo girato dalla parte sbagliata
    %must add 180 to the orientation
    gradRefined = true;
    return;
end %if rotBw(new_c(2), new_c(1)) == 1

