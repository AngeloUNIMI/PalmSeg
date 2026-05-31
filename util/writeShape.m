function writeShape(dirShapesTest_searched, input_image, shapeFinal, filename)

%create mask
bwt = poly2mask(shapeFinal(:,1), shapeFinal(:,2), size(input_image, 1), size(input_image, 2));

%superimpose border
newImg = uint8(double(input_image) + edge(bwt)*255);

% figure,imshow(input_image)
% hold on
% plot(shapeFinal(:,1), shapeFinal(:,2), 'r--', 'LineWidth', 2, 'MarkerSize', 11);
% figure,
% imshow(newImg)

%change to jpg
[C, ~] = strsplit(filename, '.');
newFilename = [C{1} '.jpg'];

%imwrite
imwrite(newImg, [dirShapesTest_searched newFilename]);

