function imgRescaled = rescaleImg(I, minI, maxI)

I = double(I);

I = I - minI;
imgRescaled = I / maxI;

