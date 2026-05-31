function L = removeCCArea(e2, thArea)

[L, ~] = bwlabel(e2);
stats_e = regionprops(e2, 'Area');
for a = 1 : numel(stats_e)
    if stats_e(a).Area < thArea
        L(L == a) = 0;
    end %if stats
end %for a

L = logical(L);