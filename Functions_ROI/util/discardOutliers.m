function [sortCoord, errorC] = discardOutliers(sortCoord, im, bw, param)

%use something based on:
%K. Ito, T. Sato, S. Aoyama, S. Sakai, S. Yusa and T. Aoki,
%"Palm region extraction for contactless palmprint recognition,"
%2015 International Conference on Biometrics (ICB), Phuket, 2015, pp. 334-340.

%Tee Connie, Andrew Teoh Beng Jin, Michael Goh Kah Ong, David Ngo Chek Ling,
%An automated palmprint recognition system, 
%Image and Vision Computing, Volume 23, Issue 5, 2005, Pages 501-515, ISSN 0262-8856,

%init
outlier = cell(2, 1);
minD = [1e9 1e9];
bestAngles = cell(2, 1);
bestAngles{1} = [360 360 360];
bestAngles{2} = [360 360 360];
errorC = 0;

%numPoints
numPoints = size(sortCoord, 1);
allind = 1:numPoints;

%all possible subsets of 3 elements taken from set of sortCoord
C = nchoosek(allind, 3);

%sortCoord

oneLoop = 0;
for i = 1 : size(C, 1)
% for i = 2
    
    %chose 3 from numPoints
    chosenPointsInd = C(i, :);
    newCoord = sortCoord(chosenPointsInd, :);
    newCoord = sortrows(newCoord, [2 1]);
    
    %assignin('base', 'newCoord', newCoord);
    %pause
   
    %CHECK 6a
    %area enclosed by chosen points must be full
    bwt = poly2mask(newCoord(:, 1), newCoord(:, 2), size(im,1), size(im,2));
    %number of elements in bwt outside palm boundaries
    numZ = numel(find(bw(bwt==1)==0));
    %number of total bwt elements
    numZtot = numel(find(bwt));
    
    %numZ / numZtot
    
    %plot
%     figure,
%     imshow(im2double(im)+imdilate(edge(bw),strel('disk',1))+imdilate(edge(bwt),strel('disk',5)),[])
%     hold on
%     plot(newCoord(:, 1), newCoord(:, 2), 'rx', 'LineWidth', 2, 'MarkerSize', 10);
    
    %CHECK 6b
    %we want two angles less than 30 (isosceles)
    %two smaller angles must not differ more than 10 degrees
    %angles
    angles = triangle_angles(newCoord, 'd');
    %numAnglesOk = numel(find(angles < 30));
    numAnglesOk = numel(find(angles < param.rejectPoints.thAngle));
    sortAngles = sort(angles, 'ascend');
    meanAngles = mean(sortAngles);
    %diffAngles = sortAngles(2) - sortAngles(1);
      
    %CHECK 6c   
    %check if extension of line from central point to other point crosses
    %other regions
    %compute coordinate of central point
    dm = pdist2(newCoord, newCoord);
    dmMean = mean(dm);
    indCentral = find(dmMean == min(dmMean));
    centralPoint = newCoord(indCentral, :);
    %compute coordinate of other points
    otherPointsInd = setdiff(1 : 3, indCentral);
    otherPointInd_1 = otherPointsInd(1);
    otherPointInd_2 = otherPointsInd(2);
    %check
    otherPoint_1 = newCoord(otherPointInd_1, :);
    blackAreaOtherPoint_1 = checkExtArea(bw, centralPoint, otherPoint_1, param);
    otherPoint_2 = newCoord(otherPointInd_2, :);
    blackAreaOtherPoint_2 = checkExtArea(bw, centralPoint, otherPoint_2, param);
    
    %CHECK 6d
    %if some coordinate lies on border, we do not want them
    ib1 = find(abs(newCoord(:,2) - size(im,1)) < param.rejectPoints.minDistanceBorder);
    ib2 = find(abs(newCoord(:,1) - size(im,2)) < param.rejectPoints.minDistanceBorder);
    ib3 = find(abs(newCoord(:,2) - size(im,1)) < param.rejectPoints.minDistanceBorder);
    ib4 = find(abs(newCoord(:,1) - size(im,2)) < param.rejectPoints.minDistanceBorder);
    ib5 = find(newCoord < param.rejectPoints.minDistanceBorder);
    ib6 = find(newCoord < param.rejectPoints.minDistanceBorder);
    
    %CHECK 6e
    %we want the 3 points in which 2 of them have minimum average distance
    %mean computed column-wise, then min is extracted
    d = min(mean(pdist2(newCoord, newCoord)));

    %combined score?
    %minimum average distance + mean of lowest 2 angles
    combScore = d + meanAngles;
    
%     pause
     
    
    %-------------------------------
    %Evaluate checks
    
    %CHECK 6a
    %if there is too much black pixels, we do not want it
    if (numZ / numZtot) > param.rejectPoints.percBlackPixels
        continue
    end %if numZ
    
    %CHECK 6b
    %we want two angles less than 30 (isosceles)
    %two smaller angles must not differ more than 10 degrees
    %if numAnglesOk < 2 || diffAngles > param.rejectPoints.thDiffAngle
    if numAnglesOk < 2
        continue
    end %if numAnglesOk
    
    %CHECK 6c
    %extension of line from central point to other point must cross
    if blackAreaOtherPoint_1 == 0 || blackAreaOtherPoint_2 == 0
        continue
    end %if blackAreaOtherPoint_1
    
    %CHECK 6d
    %if some coordinate lies on border, we do not want them
    if numel(ib1) > 0 || numel(ib2) > 0 || numel(ib3) > 0 || numel(ib4) > 0 || numel(ib5) > 0 || numel(ib6) > 0
        continue
    end %if numel(ib1) > 0 || numel(ib2) > 0

%     %CHECK 6e
%     %we want the 3 points in which 2 of them have minimum average distance
%     %mean computed column-wise, then min is extracted
%     if d < minD(1)
%         minD(2) = minD(1); %previous best
%         minD(1) = d; %new best
%         outlier{2} = outlier{1};
%         outlier{1} = setdiff(allind, chosenPointsInd);
%         bestAngles{2} = bestAngles{1};
%         bestAngles{1} = sortAngles;
%     elseif d < minD(2) %if d
%         minD(2) = d;
%         outlier{2} = setdiff(allind, chosenPointsInd);
%         bestAngles{2} = sortAngles;
%     end %if d
     
    %CHECK 6e
    %minimum combined score
    if combScore < minD(1)
        minD(2) = minD(1); %previous best
        minD(1) = combScore; %new best
        outlier{2} = outlier{1};
        outlier{1} = setdiff(allind, chosenPointsInd);
        bestAngles{2} = bestAngles{1};
        bestAngles{1} = sortAngles;
    elseif d < minD(2) %if d
        minD(2) = combScore;
        outlier{2} = setdiff(allind, chosenPointsInd);
        bestAngles{2} = sortAngles;
    end %if d
    
    %find two minimum distances
    %     dm = pdist2(newCoord, newCoord);
    %     dmV = reshape(dm, [size(dm,1)*size(dm,2) 1]);
    %     dmV = sort(dmV, 'ascend');
    %     dmV(dmV==0) = [];
    %     dmV = dmV(1:2:end); %only odd values (every distance is duplicated)
    %     d1 = dmV(1);
    %     d2 = dmV(2);
    
    %     %choose points with minimum delta
    %     delta = abs(d1 - d2) / d1;
    %     if delta < minD
    %         minD = delta;
    %         outlier = setdiff(allind, chosenPointsInd);
    %     end %if delta < minD

    %pause   
    oneLoop = 1;
end %for i

%--------------------------
% %Final selection
% %Considering CHECK 6b (angles) and CHECK 6e (minimum average distance)
% %choose among two best
% %the one with lower avg angles
% %considering the two lower angles
% meanAng{1} = mean(bestAngles{1}(1:2));
% meanAng{2} = mean(bestAngles{2}(1:2));
% if (meanAng{2} < meanAng{1}) && (minD(2) - minD(1)) < 5 %if 2nd has lesser angles, and difference in d is small
%     outlier_final = outlier{2};
% else %if meanAng{1} < meanAng{2}
%     outlier_final = outlier{1};
% end %if meanAng{1} < meanAng{2}

%points with the minimum average distance from the central
outlier_final = outlier{1};

%remove outliers
sortCoord(outlier_final, :) = [];

%CHECK 6f: Error
%no point was selected
if numel(outlier_final) == 0 && size(sortCoord, 1) > 3
    errorC = -1;
    sortCoord = [];
end %if numel
%no point was selected
if oneLoop == 0
    errorC = -1;
    sortCoord = [];
end %if numel


