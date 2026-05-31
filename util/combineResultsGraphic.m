function resAll = combineResultsGraphic(res1file, res2file, type)

res1 = imread(res1file);
res2 = imread(res2file);

%size of sep line
widthBlackLine = 5;

if strcmp(type, 'horizontal')
    resAll = uint8(zeros(max([size(res1,1),size(res2,1)]), size(res1,2)+size(res2,2)+widthBlackLine, 3));
    resAll(1:size(res1,1), 1:size(res1,2), :) = res1;
    
%     figure
%     imshow(resAll, [])
%     whos resAll res1 res2
%     pause
    
    resAll(1:size(res2,1), size(res1,2)+1+widthBlackLine:end, :) = res2;
end %if strcmp

if strcmp(type, 'vertical')
    resAll = uint8(zeros(size(res1,1)+size(res2,1), max([size(res1,2),size(res2,2)]), 3));
    resAll(1:size(res1,1), 1:size(res1,2), :) = res1;
    resAll(size(res1,1)+1:end, 1:size(res2,2), :) = res2;
end %if strcmp
