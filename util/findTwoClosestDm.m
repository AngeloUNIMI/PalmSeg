function [i_p1, i_p2, minDm] = findTwoClosestDm(sortCoord)

minDm = 1e6;
dm = pdist2(sortCoord, sortCoord);
for id = 1 : size(dm,1)
    for j = 1 : size(dm,2)
        if id == j, continue, end
        if dm(id,j) < minDm
            minDm = dm(id,j);
            i_p1 = id;
            i_p2 = j;
        end %if
    end %j
end %i
