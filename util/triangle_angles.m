function [angles]=triangle_angles(P,format)
% This function gives the angles of a triangle
%
% This function splits a triangle in two triangles with a corner of 90
% degrees (Heron's formula), and than uses a sine to calculate te angles
%
% [angles]=triangle_angles(Points, Format)
%
% Points: The Points should be a numeric array, of size 3xn, 
%         thus the points can be 2D, 3D... nD
% Format: Can be 'd' degrees or 'r' radians (default)
% 
%
% Example: 
% P1=[0 0]; P2=[0.88 0.5]; P3=[0 1];
% [angles]=triangle_angles([P1;P2;P3],'d')
%
% Version 1.3 updated on 2007-11-08

% Default output format
if(exist('format','var')==0), format='r'; end

% Check input
if((format~='r')&&(format~='d')), error('Unknown Output Format'); end
[k,m]=size(P); if(k~=3), error('Points are not a 3xn array'); end

% Length of edges
L=[sqrt(sum((P(1,:)-P(2,:)).^2)) sqrt(sum((P(2,:)-P(3,:)).^2)) sqrt(sum((P(3,:)-P(1,:)).^2))];
        
% Edge length when split in two 90 degrees triangles
s = ((L(1)+L(2)+L(3))/2); 
h = (2/L(3))*sqrt(s*(s-L(1))*(s-L(2))*(s-L(3)));
x = (L(1)^2-L(2)^2+L(3)^2)/(2*L(3));

% Angle calculations
if (format=='d')
    angles(1)=asind(h/L(1));
    if(x<0), angles(1)=180-angles(1); end
    angles(3)=asind(h/L(2));
    if(x>L(3)), angles(3)=180-angles(3); end
    angles(2)=180-angles(3)-angles(1);
else
    angles(1)=asin(h/L(1));
    if(x<0), angles(1)=pi-angles(1); end
    angles(3)=asin(h/L(2));
    if(x>L(3)), angles(3)=pi-angles(3); end
    angles(2)=pi-angles(3)-angles(1);
end


