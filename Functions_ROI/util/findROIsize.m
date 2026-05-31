function [distValleys, roisz_x, roisz_y, xOffset] = findROIsize(sortCoord, param)

%partially based on:
%Özkan Bingöl, Murat Ekinci
%Stereo-based palmprint recognition in various 3D postures
%Expert Systems with Applications, Volume 78, 2017, Pages 74-88, ISSN 0957-4174

distValleys = max(pdist(sortCoord));
roisz_x = round(distValleys * param.ROIsize.multX);
roisz_y = round(distValleys * param.ROIsize.multY);

%offset as 1/5 distance between valleys
%(Aykut 2015)
% xOffset = round(distValleys);
% xOffset = round(distValleys/2 + distValleys/5);
xOffset = round(roisz_x/2 + distValleys * param.ROIsize.multOffset);

