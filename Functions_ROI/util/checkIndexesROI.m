function result = checkIndexesROI(minRangeX, maxRangeX, minRangeY, maxRangeY, rotBw)

%1 if indexes are beyond boundaries
result = minRangeY <= 0 || maxRangeY > size(rotBw,1) || minRangeX <= 0 || maxRangeX > size(rotBw,2);

%1 if indexes are in boundaries
result = ~result;