function ROIrP = applyPreproc(ROI_single, param)


%----------------------
%enhance
%ROIr_adjusted = imadjust(ROIr);
%ROIr_adjusted = ROIr;
ROI_adjusted = adapthisteq(ROI_single);
%contrast-limited adaptive histogram equalization (CLAHE)
%Zuiderveld, Karel. "Contrast Limited Adaptive Histograph Equalization." 
%Graphic Gems IV. San Diego: Academic Press Professional, 1994. 474–485.

% figure,
% imshow(ROIr_adjusted,[])

%----------------------
%normalize
%ROIr_adjusted = normalizzaImg(ROIr_adjusted, 'std');

%----------------------
%laplacian
ROI_pad = padarray(ROI_adjusted, [param.prepProc.padSize param.prepProc.padSize], 'symmetric');
hLap = fspecial('laplacian', param.prepProc.alphaLaplacian);
imLap = imfilter(ROI_pad, hLap);
ROI_lap = ROI_pad - imLap;
ROI_crop = imcrop(ROI_lap, [param.prepProc.padSize+1 param.prepProc.padSize+1 size(ROI_single,2)-1 size(ROI_single,1)-1]);

% figure,
% imshow(ROI_lap,[])

%----------------------
%gauss
ROIrP = imgaussfilt(ROI_crop, param.prepProc.sigmaGauss);

% figure,
% imshow(ROIrP,[])

%----------------------
%normalize
%ROIrP = normalizzaImg(ROIrP, 'std');