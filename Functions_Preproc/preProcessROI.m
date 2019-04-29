function [ROIrP, ROIrP_color] = preProcessROI(ROIr, param)

%partially based on:
%Goh Kah Ong Michael, Tee Connie, Andrew Beng Jin Teoh,
%Touch-less palm print biometrics: Novel design and implementation,
%Image and Vision Computing, Volume 26, Issue 12, 2008, Pages 1551-1560, ISSN 0262-8856,


%init
ROIrP_color = [];

%convert format
ROIr = im2double(ROIr);

%----------------------
%convert
[ROI_single, ~] = convertImageSingleChannel(ROIr, param.prepProc.colorSpaceTransSingle);

%apply preprocessing
ROIrP = applyPreproc(ROI_single, param);

%apply preprocessing on the luminance channel
if size(ROIr, 3) == 3
    ROIrP_color = ROIr;
    [H, HSV] = convertImageSingleChannel(ROIr, param.prepProc.colorSpaceTransMulti);
    ROIrP_color(:,:,1) = HSV(:,:,1);
    ROIrP_color(:,:,2) = HSV(:,:,2);
    ROIrP_color(:,:,3) = applyPreproc(H, param);
    ROIrP_color = hsv2rgb(ROIrP_color);
end %if size


