function newImg = zeroBorder(img)

newImg = zeros(size(img, 1), size(img, 2));
newImg(5:end-5, 5:end-5, :) = img(5:end-5, 5:end-5, :);