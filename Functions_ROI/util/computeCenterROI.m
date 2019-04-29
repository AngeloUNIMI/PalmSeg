function new_c = computeCenterROI(top1, top2, bottom1, bottom2, xOffset)

new_c = [round((top1(1)+bottom1(1))/2)+xOffset, round(((min(top2)+max(top2))/2+bottom2(1))/2)];