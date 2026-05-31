function gradMod = estOrient(sortCoord, i_p1, i_p2)


%Angle of rotation to keep point 1 and 3 in the horizontal...
% grad = (  atan(  (sortCoord(3,2) - sortCoord(1,2)) / (sortCoord(3,1)-sortCoord(1,1))  )  ) * 180/pi
% grad = rad2deg(  atan(  (sortCoord(3,2) - sortCoord(1,2)) / (sortCoord(3,1)-sortCoord(1,1))  )  );
% grad = rad2deg(atan((sortCoord(i_p2,2) - sortCoord(i_p1,2)) / (sortCoord(i_p2,1) - sortCoord(i_p1,1)))) %diffY / diffX
% assignin('base', 'angle', grad);

% diffY = sortCoord(i_p2,2) - sortCoord(i_p1,2);
% diffX = sortCoord(i_p2,1) - sortCoord(i_p1,1);
% if abs(diffY) > abs(diffX)
%     grad = -90 - rad2deg(atan(diffX / diffY));
% else
%     grad = rad2deg(atan(diffY / diffX));
% end

diffY = sortCoord(i_p2,2) - sortCoord(i_p1,2);
diffX = sortCoord(i_p2,1) - sortCoord(i_p1,1);
grad = rad2deg(atan(diffY / diffX));


%PROCESS ORIENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gradMod = -90 - grad;
% gradMod = grad;

% if grad >= 0
    %grad = 90 - grad;
% else %if rp(1).Orientation < 0
%     gradMod = -90 - grad;
    %grad = 90 - grad - 180;
% end %if rp(1).Orientation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fprintf(1, ['Orient: ' num2str(grad) '\n']);
% fprintf(1, ['Orient mod: ' num2str(gradMod) '\n']);
