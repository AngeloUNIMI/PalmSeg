function [img, minimo, massimo] = normalizzaImg(I, type)

%types
    %std
    %nozeros

if nargin < 2
    type = 'std';
end %if nargin

I = double(I);
if strcmp(type, 'std')
    minimo = min(I(:));
end %if strcmp
if strcmp(type, 'nozeros')
    Inz = I(I~=0);
    minimo = min(Inz(:));
end%if strcmp
I = I - minimo;

massimo = max(I(:));

img = I / massimo;
