function [i_p1, i_p2, maxP] = findMostDistPoints(sortCoord)

dm = pdist2(sortCoord, sortCoord);
maxP = max(dm(:));
[i,j] = find(dm == maxP);

i_p1 = i(1);
i_p2 = j(1);