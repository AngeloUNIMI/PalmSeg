function [zeroIm1, zeroIm2] = createCentroidImages(w_orig, h_orig, sortCoord, i_p1, i_p2)

zeroIm1 = zeros(w_orig, h_orig);
zeroIm2 = zeros(w_orig, h_orig);
zeroIm1(round(sortCoord(i_p1,2))-2:round(sortCoord(i_p1,2))+2,round(sortCoord(i_p1,1))-2:round(sortCoord(i_p1,1))+2) = 255;
zeroIm2(round(sortCoord(i_p2,2))-2:round(sortCoord(i_p2,2))+2,round(sortCoord(i_p2,1))-2:round(sortCoord(i_p2,1))+2) = 255;