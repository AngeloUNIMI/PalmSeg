function numCons = numConsEls(vector, value)

%init
numCons = -1;

for s = 1 : length(vector)
    v2 = circshift(vector, s);
    C = SplitVec(v2);
    for c = 1 : numel(C)
        if mean(C{c}) ~= value
            %niente
        else %if mean(C)
            lc = length(C{c});
            if lc > numCons
                numCons = lc;
            end %if n
        end %if mean(C)
    end %for c
    %n = max(SplitVec(v2,[],'length'));
end %for s