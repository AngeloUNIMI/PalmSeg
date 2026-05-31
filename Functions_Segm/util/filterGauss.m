function C = filterGauss(input_image, size, stdd)

G = fspecial('gaussian', size, stdd);
C = imfilter(input_image, G, 'same');

