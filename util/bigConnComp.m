function mask = bigConnComp(mask, fill)


%cast
mask = logical(mask);

%number of cc
[L, ~] = bwlabel(mask, 8);

stats = regionprops(mask, 'Area');
maxArea = max([stats.Area]);

for s = 1 : numel(stats)
    if stats(s).Area < maxArea
        mask(L==s) = 0;
    end %if stats
end %for s

if fill
    mask = logical(imfill(mask, 'holes'));
end %if fill



