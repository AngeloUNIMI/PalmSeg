function neigh = findNeigh(bw, point, distance, offsetA, numNeigh)

%init
neigh = [];

%round
%point: (x,y)
point = round(point);

%check indices
if point(2) + distance > size(bw, 1) || point(1) + distance > size(bw, 2)
    return;
end %if point
if point(2) - distance <= 0 || point(1) - distance <= 0
    return;
end %if point

neigh = zeros(numNeigh, 1);
countN = 1;
for angle = 0 : (360/numNeigh) : (360 - 360/numNeigh)
    neigh(countN) = bw(point(2) + round(distance*sin(deg2rad(angle+offsetA))), point(1) + round(distance*cos(deg2rad(angle+offsetA))));
    countN = countN + 1;
end %for angle

