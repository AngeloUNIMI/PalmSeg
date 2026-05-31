function [shapeFinal, centroid, orientM, bw_e_smooth] = segmentPalms(input_image, param, dbname, filename, jpgFiles, savefile, plotta)

%partially based on:
%K. Ito, T. Sato, S. Aoyama, S. Sakai, S. Yusa and T. Aoki,
%"Palm region extraction for contactless palmprint recognition,"
%2015 International Conference on Biometrics (ICB), Phuket, 2015, pp. 334-340.

%----------------------
%output: image without modifications
input_image_original = input_image;

%----------------------
%convert
input_image = convertImageSingleChannel(input_image_original, param.segm.colorSpaceTrans); 

%----------------------
%resize
input_image = imresize(input_image, param.segm.resizeF);
input_image_color = imresize(input_image_original, param.segm.resizeF);

%----------------------
%enhance
input_image = imadjust(input_image, stretchlim(input_image, [0.01 0.99]));

%----------------------
%normalize
if param.segm.normalizza == 1
    input_image = normalizzaImg(input_image);
    input_image_color = normalizzaImg(input_image_color);
end %if param.normalizza = 1


%----------------------
%gaussian smoothing filter
C = filterGauss(input_image, param.segm.fGauss_size, param.segm.fGauss_sigma);
C_uint8 = im2uint8(C);

%----------------------
%threshold
binar = thresholdPalm(C, param);

% figure,
% imshow(binar)
% pause

% %select bigger cc and fill
% binar = bigConnComp(binar, 1);

%----------------------
%first edge to add
vess = VesselExtract(C_uint8, 0);
[vess, minVess, maxVess] = normalizzaImg(vess);
vess2 = zeroBorder(vess);
% vess2 = vess;
[thVessF, ~] = graythresh(vess2);
edge_added = vess2 > thVessF;

%morph
edge_added = imclose(edge_added, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
edge_added = imopen(edge_added, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));

%add to image
if param.segm.useEdgeAdd
    binar_plus_edge = binar + edge_added;
    binar_plus_edge(binar_plus_edge~=0) = 1;
    binar_plus_edge = logical(binar_plus_edge);
    %morph
    binar_plus_edge = imclose(binar_plus_edge, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
    binar_plus_edge = imfill(binar_plus_edge, 'holes');
    binar_plus_edge = imopen(binar_plus_edge, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
else %if param.segm.useEdgeAdd
    binar_plus_edge = binar;
end %if param.segm.useEdgeAdd
%select bigger cc and fill
binar_plus_edge = bigConnComp(binar_plus_edge, 1);

%----------------------
%look for orientation that gives minimum ratio
%between horizontal edges and vertical edges
%then we keep the horizontal edges image
%compute horizontal and vertical edges so we have the orientation approx
%vertical edges: borders of fingers
[edgeM_ho, edgeM_ve, orientM] = findOrientBasedonEdge(C, C_uint8, thVessF, param);
% orientM
%apply normalization based on global vess
edgeM_ho = rescaleImg(edgeM_ho, minVess, maxVess);
edgeM_ve = rescaleImg(edgeM_ve, minVess, maxVess);
%thresholding
%vertical
thVessVe = thVessF + param.segm.thVessModVe;
edge_removed_orig = edgeM_ve > thVessVe; %rendiamo morbida la soglia per gli edge verticali
%horizontal
thVessHo = thVessF + param.segm.thVessModHo;
refl_orig = edgeM_ho > thVessHo;
    
%----------------------
%vertical edges: edges to remove
orientLineStrel = 90 - orientM;
if param.segm.subEdgesVer
    
    %init
    edge_removed = edge_removed_orig;
    
    %subtract horizontal image
    edge_removed = edge_removed - refl_orig;
    %edge_removed = edge_removed - imerode(refl_orig, strel(param.segm.typeStrel, param.segm.sizeStrel_small));
    edge_removed(edge_removed~=1) = 0;
    
    edge_removed = imdilate(edge_removed, strel(param.segm.typeStrelEdge, param.segm.sizeStrelEdge_small, orientLineStrel));
    edge_removed = imclose(edge_removed, strel(param.segm.typeStrelEdge, param.segm.sizeStrelEdge_huge, orientLineStrel));
    edge_removed = imopen(edge_removed, strel(param.segm.typeStrelEdge, param.segm.sizeStrelEdge_medium, orientLineStrel));
    %edge_removed = imopen(edge_removed, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
    %remove cc with area less than 300
    edge_removed = removeCCArea(edge_removed, param.segm.thArea);
    
    %subtract from original image
    binar_minus_edge = binar_plus_edge - edge_removed;
    binar_minus_edge(binar_minus_edge~=1) = 0;
    binar_minus_edge = logical(binar_minus_edge);
    
    %morph
    binar_minus_edge = imopen(binar_minus_edge, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
    %binar_minus_edge = imclose(binar_minus_edge, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
else %if param.segm.subEdgesVer
    edge_removed = edge_removed_orig;
    binar_minus_edge = binar_plus_edge;
end %if param.segm.subEdgesVer


%----------------------
%horizontal edges: reflections or palm lines
if param.segm.useRefl
    
    %init
    refl = refl_orig;
    
    %subtract vert image
    refl = refl - edge_removed_orig;
    refl(refl~=1) = 0;
    
    %morph refl image
    refl = imdilate(refl, strel(param.segm.typeStrelEdge, param.segm.sizeStrelEdge_small, orientLineStrel-90));
    refl = imclose(refl, strel(param.segm.typeStrelEdge, param.segm.sizeStrelEdge_large, orientLineStrel-90));
    %refl = imopen(refl, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
    
    binar_plus_refl = binar_minus_edge + refl;
    binar_plus_refl(binar_plus_refl~=0) = 1;
    binar_plus_refl = logical(binar_plus_refl);
    %fill
    binar_plus_refl = imfill(binar_plus_refl, 'holes');
    
    %morph image after adding reflections
    binar_plus_refl = imopen(binar_plus_refl, strel(param.segm.typeStrel, param.segm.sizeStrel_large));
    %binar_plus_refl = imclose(binar_plus_refl, strel(param.segm.typeStrel, param.segm.sizeStrel_medium));
else %if param.segm.useRefl
    refl = refl_orig;
    binar_plus_refl = binar_minus_edge;
end %%if param.segm.useRefl

%----------------------
%select bigger cc and fill
binar_plus_refl = bigConnComp(binar_plus_refl, 1);

%----------------------
%invert resize
binar_plus_refl = imresize(binar_plus_refl, 1/param.segm.resizeF);

% figure,
% imshow(binar_plus_refl,[])

%----------------------
%Detect the Boundary
[B, ~, ~] = bwboundaries(binar_plus_refl);
%The bwboundaries function implements the Moore-Neighbor tracing algorithm
%modified by Jacob's stopping criteria. This function is based on the
%boundaries function presented in the first edition of Digital Image
%Processing Using MATLAB, by Gonzalez, R. C., R. E. Woods, and S. L. Eddins,
%New Jersey, Pearson Prentice Hall, 2004.

%----------------------
%centroid
centroid = regionprops(binar_plus_refl, 'Centroid');
centroid = centroid(1).Centroid;

%This is the edge we are interested in
outline = flipud(B{1});

%x,y coord
shapeFinal(:,1) = outline(:,2);
shapeFinal(:,2) = outline(:,1);

%----------------------
%interpolate shape to common size
shapeFinal = resizem(shapeFinal, [param.segm.sizeShapeInterp 2], 'bilinear');

%----------------------
%Smoothing
windowWidth = roundOdd(param.segm.smoothShapeSize); %11
% shapeFinal(:,1) = sgolayfilt(shapeFinal(:,1), param.segm.smoothShapeOrder, windowWidth);
% shapeFinal(:,2) = sgolayfilt(shapeFinal(:,2), param.segm.smoothShapeOrder, windowWidth);
shapeFinal(:,1) = smooth(shapeFinal(:,1), windowWidth);
shapeFinal(:,2) = smooth(shapeFinal(:,2), windowWidth);

%----------------------
%binary mask from smoother border
bw_e_smooth = poly2mask(shapeFinal(:, 1), shapeFinal(:, 2), size(input_image_original,1), size(input_image_original,2));

%----------------------
%plot
if plotta
    
    fh = fsfigure(1);
    
    subplot(2,3,1)
    imshow(edge_added,[])
    title('Edge image to add')
    
    subplot(2,3,2)
    imshow(binar_plus_edge,[])
    title('Otsu + edge image added')

    subplot(2,3,3)
    imshow(edge_removed,[])
    title('Edge image to remove, closed')
    
    subplot(2,3,4)
    imshow(binar_minus_edge,[])
    title('Edge image removed, opened')
    
    subplot(2,3,5)
    imshow(refl,[])
    title('Reflections to add')
    
    subplot(2,3,6)
    imshow(binar_plus_refl,[])
    title('Reflections added and final segmentation')
    hold on
    plot(shapeFinal(:,1), shapeFinal(:,2), 'r--', 'LineWidth', 2, 'MarkerSize', 11);
    hold off
    legend('Final segmentation', 'Location', 'southeast');
    
    mtit(fh, [dbname ' - ' filename], 'Interpreter', 'none', 'fontsize', 14, 'color', [1 0 0], 'xoff', .0, 'yoff', .04);

    if savefile
        C = strsplit(filename, '.');
        export_fig([jpgFiles C{1} '_Segm.jpg'], '-q50');
    end %if savefile
    
end %if plotta



