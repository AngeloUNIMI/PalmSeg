function indPoints_new = localSearchValleys(im, bw, shapeF, indPoints, param)

%partially based on:
%Goh Kah Ong Michael, Tee Connie, Andrew Beng Jin Teoh,
%Touch-less palm print biometrics: Novel design and implementation,
%Image and Vision Computing, Volume 26, Issue 12, 2008, Pages 1551-1560, ISSN 0262-8856,

%init
indPoints_new = indPoints;

%convert to x,y
shapeN(:,1) = shapeF(:,2);
shapeN(:,2) = shapeF(:,1);
shapeF = shapeN;

%check 3 conditions
indexrem = [];
for i = 1 : numel(indPoints)
     
%     %extract point
%     point = shapeF(indPoints(i), :);

%     i, 
%     figure(11),
%     imshow(im2double(im)),
%     hold on
%     plot(shapeF(:,1), shapeF(:,2), 'w-');
%     plot(shapeF(indPoints,1), shapeF(indPoints,2), 'rx');
%     plot(point(1), point(2), 'gx');
%     
%     %evaluate conditions
%     [cond1, cond2, cond3] = evalCond(point, bw, param)
%     
%     pause
    
    %if cond1 && cond2 && cond3
        %ok
    %else %if cond1
        %ricerca locale
        
        %init
        cumS = zeros(param.localsearch.offset+2, 1);
        countCumS = 1;
        
        %extreme
        extrR = round(param.localsearch.offset/2);
        %check if goes beyond size
        %if positive, modify extreme
        if indPoints(i) - extrR <= 0 
            extrR = indPoints(i) - 1;
        end %if indPoints
        if indPoints(i) + extrR > size(shapeF,1)
            extrR = size(shapeF,1) - indPoints(i);
        end %if indPoints
        
        for s = indPoints(i) - extrR: param.localsearch.stepSearch : indPoints(i) + extrR
            %s
            point = shapeF(s, :);
            
            %check maximum distance
            if pdist2(point, shapeF(indPoints(i),:)) > param.localsearch.maxDistance
                continue
            end %if pdist2
            
            [cond1S, cond2S, cond3S] = evalCond(point, bw, param);
            if cond1S && cond2S && cond3S
                %substitute point in shape indices
                cumS(countCumS) = s;
                countCumS = countCumS + 1;
            end %if cond1S
        end %for s
        %cumS
        cumS(countCumS:end) = [];
        %indPoints_new(i) = round(median(cumS));
        if numel(cumS) > 0
            indPoints_new(i) = round(mean(cumS));
            %indPoints_new(i) = round(median(cumS));
        else %if numel(cumS) > 0
            %indexrem = [indexrem i];
            indPoints_new(i) = indPoints(i);
        end %if numel(cumS) > 0
    %end %if cond1

    %plot new point
%     cond1, cond2, cond3
%     point = shapeF(indPoints_new(i), :);
%     plot(point(1), point(2), 'bo');
%     hold off
%     pause
    
end %for i

%remove discarded points
indPoints_new(indexrem) = [];

