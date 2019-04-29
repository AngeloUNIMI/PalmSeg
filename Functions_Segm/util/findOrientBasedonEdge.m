function [reflM_ho_vessel, reflM_ve_vessel, orientM] = findOrientBasedonEdge(C, C_uint8, thVessF, param)

%orig size
[h_orig, w_orig] = size(C_uint8);

areaM = 1e9;
for orient_rot = -90 : 5 : 90
    
    C_rot = imrotate(C, orient_rot, 'crop');
    
    [~, th_e] = edge(C_rot, 'sobel');
    e_ho = edge(C_rot, 'Sobel', th_e, 'horizontal', 'nothinning'); %detect rings?
    e_ve = edge(C_rot, 'Sobel', th_e, 'vertical', 'nothinning'); %detect rings?

%     e_ho = VesselExtract(C_rot, 0, 'horizontal', param.segm.indKirschVer, param.segm.indKirschHor) > thVessF;
%     e_ve = VesselExtract(C_rot, 0, 'vertical', param.segm.indKirschVer, param.segm.indKirschHor) > thVessF;
    
    refl_ho = imrotate(e_ho, -orient_rot, 'crop');
    refl_ve = imrotate(e_ve, -orient_rot, 'crop');
    areas_ho = regionprops(refl_ho, 'Area');
    areas_ve = regionprops(refl_ve, 'Area');
    
    cond = sum([areas_ho.Area]) / sum([areas_ve.Area]);
    
    if cond < areaM
        areaM = cond;
        %reflM_ho = refl_ho;
        %reflM_ve = refl_ve;
        orientM = orient_rot;
    end %if sum
    
end %for orient_rot

%horizontal edges
%maximum by varying +- 5 degrees
reflM_ho_vessel = zeros(size(C_uint8));
for orientV = orientM - param.segm.edgeHoSearchAngle : orientM + param.segm.edgeHoSearchAngle
    
    C_rot = imrotate(C_uint8, orientV);
    vess = VesselExtract(C_rot, 0, 'horizontal', param.segm.indKirschVer, param.segm.indKirschHor);
    %reflM_ho_vessel = imrotate(vess2, -orientM, 'crop');
    vess2 = imrotate(vess, -orientV);
    %compensate differences in size due to rotations
    vess3 = compensateCropBB(vess2, h_orig, w_orig);
    vess4 = zeroBorder(vess3);
%     vess4 = vess3;
    
    tempVess = zeros(size(C_uint8, 1), size(C_uint8, 2));
    tempVess(:,:,1) = reflM_ho_vessel;
    tempVess(:,:,2) = vess4;
    
    reflM_ho_vessel = max(tempVess, [], 3);
    
end %for orientV

% figure(11),
% imshow(reflM_ho_vessel,[])
% pause


%vertical edges are not always vertical
%maximum by varying +- 5 degrees
reflM_ve_vessel = zeros(size(C_uint8));
for orientV = orientM - param.segm.edgeVeSearchAngle : orientM + param.segm.edgeVeSearchAngle
    
    C_rot = imrotate(C_uint8, orientV);
    vess = VesselExtract(C_rot, 0, 'vertical', param.segm.indKirschVer, param.segm.indKirschHor);
    %reflM_ve_vessel = imrotate(vess2, -orientM, 'crop');
    vess2 = imrotate(vess, -orientV);
    %compensate differences in size due to rotations
    vess3 = compensateCropBB(vess2, h_orig, w_orig);
    vess4 = zeroBorder(vess3);
%     vess4 = vess3;
    
    tempVess = zeros(size(C_uint8, 1), size(C_uint8, 2));
    tempVess(:,:,1) = reflM_ve_vessel;
    tempVess(:,:,2) = vess4;
    
    reflM_ve_vessel = max(tempVess, [], 3);
    
end %for orientV

% figure(11),
% imshow(reflM_ve_vessel,[])
% pause


