function [cond1, cond2, cond3] = evalCond(point, bwRot, param)

%init
cond1 = false;
cond2 = false;
cond3 = false;

for offsetA = 0 : param.localsearch.stepAngle : 90
%for offsetA = 3
    
    neigh4 = findNeigh(bwRot, point, param.localsearch.beta, offsetA, 4);
    if numel(neigh4) > 0
        cond1 = numel(find(neigh4==0)) == 1;
        %else %if numel(neigh4) > 0
        %    cond1 = false;
    else %if numel(neigh4) > 0
        cond1 = true; %se va fuori, è true
    end %if numel
    
    neigh8 = findNeigh(bwRot, point, param.localsearch.beta+param.localsearch.alpha, offsetA, 8);
    if numel(neigh8) > 0
        cond2 = numel(find(neigh8==0)>=1) && numConsEls(neigh8, 0) <= 4;
        %else %if numel(neigh8) > 0
        %    cond2 = false;
    else %if numel(neigh8) > 0
        cond2 = true; %se va fuori, è true
    end %if numel
    
    neigh16 = findNeigh(bwRot, point, param.localsearch.beta+param.localsearch.alpha+param.localsearch.mu, offsetA, 16);
    if numel(neigh16) > 0
        cond3 = numel(find(neigh16==0) >= 1) && numel(find(neigh16==0) <= 7);
        %else %if numel(neigh16) > 0
        %    cond3 = false;
    else %if numel(neigh16) > 0
        cond3 = true; %se va fuori, è true
    end %if numel
    
    if cond1 && cond2 && cond3
        return;
    end %if cond1
    
end %for offsetA