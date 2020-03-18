%PARAMS FOR
%CASIA_PalmprintV1
%--------------------------------------

%segmentation params
param.segm.resizeF = 1;
param.segm.colorSpaceTrans = 'rgb2ycbcr';
param.segm.th_em = 0.85; %segmentation effectiveness threshold
param.segm.thSegmRed = -0.00; %reduction factor for binarization threshold (pos. values = harder threshold)
param.segm.numCCbinar = 10; %num of cc after which binarization is messy
param.segm.thVessModVe = 0.00; %-0.03 %threshold add factor for vertical edges (pos. values = harder threshold)
param.segm.thVessModHo = 0.00; %threshold add factor for horizontal edges (pos. values = harder threshold)
param.segm.indKirschVer = [1 2]; %[1 2 3 4 7 8]
param.segm.indKirschHor = [5 6]; %[5 6 3 4 7 8]
param.segm.edgeVeSearchAngle = 5;
param.segm.edgeHoSearchAngle = 2;
param.segm.useEdgeAdd = 1;
param.segm.subEdgesVer = 1; %subtract vertical edges
param.segm.useRefl = 1; %add reflections / horizontal edges
param.segm.reflEdgeMult = 1.0; %coeff moltp per soglia edge sobel
param.segm.thArea = 300; %minimum cc area for vertical edge removal
param.segm.fGauss_size = [5 5];
param.segm.fGauss_sigma = 2;
param.segm.typeStrel = 'disk';
param.segm.sizeStrel_small = 1;
param.segm.sizeStrel_medium = 3;
param.segm.sizeStrel_large = 5;
param.segm.typeStrelEdge = 'line';
param.segm.sizeStrelEdge_small = 3;
param.segm.sizeStrelEdge_medium = 5;
param.segm.sizeStrelEdge_large = 15;
param.segm.sizeStrelEdge_huge = 20; %30
param.segm.sizeShapeInterp = 3000;
param.segm.smoothShapeSize = 50; %100 for Savitsky-Golay / 50 for MA
param.segm.smoothShapeOrder = 2;

%peak finding params
param.peakFind.numIterCentroid = 1; %number of iterations to refine centroid (not working so well)
param.peakFind.smoothF = 150; %smoothing factor in searching peaks (valleys) from segmentations %100
param.peakFind.minPeakDistance = param.segm.sizeShapeInterp / 60; %50
param.peakFind.meanPksMult = 1.2;

%local search params
%THESE PROBABLY NEED TO BE TUNED FOR EACH DB
param.localsearch.beta = 20;
param.localsearch.alpha = 20;
param.localsearch.mu = 20;
%param.localsearch.localSearchOffset = round(param.peakFind.minPeakDistance / 5); %5
param.localsearch.offset = 300; %300 %molto alto
param.localsearch.maxDistance = 50; %questo delimita le aree di ricerca
param.localsearch.stepSearch = 5;
param.localsearch.stepAngle = 5;

%reject points params
param.rejectPoints.thAngle = 35; %30
param.rejectPoints.thDiffAngle = 10;
param.rejectPoints.percBlackPixels = 0.05; %0.05
param.rejectPoints.percCheckExtArea = 0.3;
param.rejectPoints.numStepsCheckExtArea = 10;
param.rejectPoints.minDistanceBorder = 5;

%roi size params
%use these to refine grad
param.ROIsize.useRefineGrad = 1;
param.ROIsize.sizeROI = [150 150]; %empirical based on papers (128-150)
param.ROIsize.multX = 1.4;
param.ROIsize.multY = 1 + 2/5;
param.ROIsize.multOffset = 1/5; %es. 1/5 of distance between valleys
param.ROIsize.percBlackPixels = 0.30;




