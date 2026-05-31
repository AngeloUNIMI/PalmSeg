function [minRangeX, maxRangeX, minRangeY, maxRangeY] = computeRangesROI(new_c, roisz_x, roisz_y)

minRangeX = new_c(1) - round(roisz_x/2) + 1;
maxRangeX = new_c(1) + round(roisz_x/2);

minRangeY = new_c(2) - round(roisz_y/2) + 1;
maxRangeY = new_c(2) + round(roisz_y/2);
