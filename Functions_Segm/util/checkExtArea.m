function blackAreaOtherPointFinal = checkExtArea(bw, centralPoint, otherPoint, param)

%distance to check as fraction of distance bewteen point and central point
distRed = 1/param.rejectPoints.numStepsCheckExtArea;

%init
blackAreaOtherPointFinal = false;

%distance from central point
distX = otherPoint(1) - centralPoint(1);
distY = otherPoint(2) - centralPoint(2);

%gradually increase distance to check
%if doesn't find anything or goes out the boundary, is false
blackAreaOtherPointV = false(param.rejectPoints.numStepsCheckExtArea, 1);
for mult = 1 : param.rejectPoints.numStepsCheckExtArea
%for mult = 2
    
    newPointX = otherPoint(1) + mult * distRed * distX;
    newPointY = otherPoint(2) + mult * distRed * distY;
    
%     %plot
%     plot(newPointX, newPointY, 'gx')
    
    if newPointX <= 1 || newPointX >= size(bw,2)
        blackAreaOtherPoint  = false;
        %put value in vector
        blackAreaOtherPointV(mult) = blackAreaOtherPoint;
        %return;
        break;
    end %if newPointX
    if newPointY <= 1 || newPointY >= size(bw,1)
        blackAreaOtherPoint  = false;
        %put value in vector
        blackAreaOtherPointV(mult) = blackAreaOtherPoint;
        %return;
        break;
    end %if newPointX
    
    
    %check if intersects hand areas
    blackAreaOtherPoint = logical(bw(round(newPointY), round(newPointX)));
    %put value in vector
    blackAreaOtherPointV(mult) = blackAreaOtherPoint;
    
    %if its true then stop
    if blackAreaOtherPoint == true
        %return
    end %if blackAreaOtherPoint
    
    
end %for mult

%remove excess
blackAreaOtherPointV(mult+1:end) = [];

%majority of pixels must be 1
if numel(find(blackAreaOtherPointV)) > numel(blackAreaOtherPointV) * param.rejectPoints.percCheckExtArea
    blackAreaOtherPointFinal = true;
end %if numel




