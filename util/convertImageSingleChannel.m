function [input_image_single_original, convColor] = convertImageSingleChannel(input_image, type)

%init
convColor = [];
if nargin < 2
    type = 'rgb2gray';
end %if nargin

%convert
if size(input_image, 3) == 3
    
    switch type
        case 'rgb2gray'
            input_image_single_original = rgb2gray(input_image);
        case 'rgb2ycbcr'
            convColor = rgb2ycbcr(input_image);
            input_image_single_original = convColor(:,:,1);
        case 'rgb2hsv'
            convColor = rgb2hsv(input_image);
            input_image_single_original = convColor(:,:,3);
    end %switch
            
                      
else %if size(input_image, 3) == 3
    input_image_single_original = input_image; %this is output: image without modifications
end %if size(input_image, 3) == 3

