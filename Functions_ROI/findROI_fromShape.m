function [ROIr, errorC, resultsROI] = findROI_fromShape(im, bw, shapeF, centroid, param, dbname, filename, jpgFiles, savefile, plotta)

%-----------------------------------------------
%init
errorC = [0 0]; %ok
ROIr = [];
resultsROI = [];

%size of image
w_orig = size(im,1); 
h_orig = size(im,2);

%row/coord
shapeN(:,1) = shapeF(:,2);
shapeN(:,2) = shapeF(:,1);
shapeF = shapeN;


%-----------------------------------------------
%repeat multiple times
%each time the computed centroid is used to compute again the distances
%between the centroid and the border points
for iterations = 1 : param.peakFind.numIterCentroid
    
    %-----------------------------------------------
    %Put all coordinates and distances in the same array
    regionLine = zeros(length(shapeF), 3);
    for i = 1:length(shapeF)
        regionLine(i,:) = [shapeF(i,2) shapeF(i,1) sqrt((shapeF(i,2)-centroid(1))^2+(shapeF(i,1)-centroid(2))^2)];
    end %for i = 1:length(shapeF)
      
    %-----------------
    %CHECK 1: Smooth distance of border from centroid
    smoothedDistPeaks = smooth(-regionLine(:,3), param.peakFind.smoothF);
    
    %-----------------
    %CHECK 2: Select peaks with a minimum distance between them
    [~, ind_peaks, ~, prominences] = findpeaks(smoothedDistPeaks, 'MinPeakDistance', param.peakFind.minPeakDistance, 'MinPeakProminence', 5);
    
    %CHECK 3: if less than 3 peaks found, model not good
    if numel(prominences) < 3
        if iterations == 1
            fprintf(1, '\t\tToo few peaks\n');
            errorC = -1;
            return;
        end %if iterations
        break;
    end %if numel(p)
    
    %minima of interest
    coordinates_orig = regionLine(ind_peaks, 1:2);
     
    %CHECK 4: remove smaller peaks
    %(May create problems)
    %meanP = mean(pks) * param.peakFind.meanPksMult;
    %ind_peaks = ind_peaks(pks >= meanP);
    
    %Savitsky-Golay filter for smoothing
    % polynomialOrder = 2;
    % windowWidth = roundOdd(smoothF); %11
    % smoothRL = -sgolayfilt(regionLine(:,3), polynomialOrder, windowWidth);
    % [~, i, ~, p] = findpeaks(smoothRL, 'MinPeakDistance', 20, 'MinPeakHeight', mean(-regionLine(:,3)));
    % figure,findpeaks(smoothRL, 'MinPeakDistance', 20, 'MinPeakHeight', mean(-regionLine(:,3)));
    % pause
    
    %-----------------
    %CHECK 5: Local search
    ind_peaks_new = localSearchValleys(im, bw, shapeF, ind_peaks, param);
    coordinates = regionLine(ind_peaks_new, 1:2);
    
    %Sort the coordinates from top of image to bottom, and from left to right
    [sortCoord, ~] = sortrows(coordinates, [2 1]);
       
    %-----------------
    %CHECK 6: Reject points by analyzing sets of 3s
    [sortCoord, errorC(1)] = discardOutliers(sortCoord, im, bw, param);
    if errorC(1) == -1
        break;
    end %if errorC
    
    %-----------------
    %Find size of the roi
    [~, roisz_x, roisz_y, xOffset] = findROIsize(sortCoord, param);

    %-----------------
    %find the most distant points to compute orientation
    [i_p1, i_p2] = findMostDistPoints(sortCoord);
    
    %-----------------
    %estimate orientation
    grad = estOrient(sortCoord, i_p1, i_p2);
    
    %-----------------
    %Keeping track of the centroid after rotation
    [zeroIm1, zeroIm2] = createCentroidImages(w_orig, h_orig, sortCoord, i_p1, i_p2);
    
    %-----------------
    %we try both orientations (0 and -180) to see if one is wrong
    if param.ROIsize.useRefineGrad
        gradRefined = refineGrad(im, bw, zeroIm1, zeroIm2, grad, roisz_x, roisz_y, xOffset, param);
    else %if param.ROIsize.useRefineGrad
        gradRefined = false;
    end %if param.ROIsize.useRefineGrad
    
    %-----------------
    %compute possible ROI area based on extended ROI size
    [ROIout, rotPalm, new_c, top1, top2, bottom1, bottom2, errorC(2)] = ...
        computeROI(im, bw, zeroIm1, zeroIm2, grad, gradRefined, roisz_x, roisz_y, xOffset, param);
    if errorC(2) == -1
        break;
    end %if errorC
    
    %-----------------------------------------------
    %create data structure
    resultsROI.gradRefined = gradRefined;
    resultsROI.valleyPoints = sortCoord;
    %resultsROI.CenterROI = new_c;
    
end %for iterations = 1 : 2


%-----------------------------------------------
%resize to uniform
if errorC(1) == 0 && errorC(2) == 0
    ROIr = imresize(ROIout, param.ROIsize.sizeROI, 'bicubic');
else %if errorC
    ROIr = zeros(size(im));
end %if errorC


%-----------------------------------------------
%plot
if plotta  
    fh = fsfigure(2);
    subplot(2,2,1)
    imshow(im,[])
    hold on,
    plot(shapeF(:,2), shapeF(:,1), 'r--', 'LineWidth', 2, 'MarkerSize', 11);
    title('Segmentation');
    
    subplot(2,2,2)
    imshow(im,[])
    hold on,
    plot(coordinates_orig(:,1), coordinates_orig(:,2), 'rs', 'LineWidth', 2, 'MarkerSize', 15);
    plot(coordinates(:,1), coordinates(:,2), 'gx', 'LineWidth', 2, 'MarkerSize', 10);
    
    if errorC(1) == 0
        plot(sortCoord(:,1), sortCoord(:,2), 'bo', 'LineWidth', 2, 'MarkerSize', 10);
        title('Found coordinates');
        legend({'Original coordinates', 'After local search', 'Selected coordinates'}, 'Location', 'southeast');
    end %if errorC(1)
    
    if errorC(1) == 0 && errorC(2) == 0
        subplot(2,2,3)
        imshow(rotPalm,[])
        hold on
        plot(new_c(1),new_c(2),'b*', 'LineWidth', 2, 'MarkerSize', 10)
        %rectangle('Position',[new_c(1)-round(roisz/2),new_c(2)-round(roisz/2),roisz,roisz])
        rectangle('Position',[new_c(1)-round(roisz_x/2),new_c(2)-round(roisz_y/2),roisz_x,roisz_y])
        plot(top1(1),top2(1),'r*',  'LineWidth', 2, 'MarkerSize', 10)
        plot(bottom1(1),bottom2(1),'g*',  'LineWidth', 2, 'MarkerSize', 10)
        title('Normalized and Rotated');
        
        subplot(2,2,4)
        imshow(ROIr,[])
        title({filename, 'Possible ROI'}, 'Interpreter', 'None')
    end %if errorC(1)
    
    mtit(fh, [dbname ' - ' filename], 'Interpreter', 'none', 'fontsize', 14, 'color', [1 0 0], 'xoff', .0, 'yoff', .04);
    
    if savefile
        C = strsplit(filename, '.');
        export_fig([jpgFiles C{1} '_ROI.jpg'], '-q50');
    end %if savefile
end %if plotta




