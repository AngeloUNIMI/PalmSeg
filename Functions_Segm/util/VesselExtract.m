%Program for Retinal Blood Vessel Extraction

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

%Kirsch, R. (1971).
%"Computer determination of the constituent structure of biological images".
%Computers and Biomedical Research. 4: 315–328. doi:10.1016/0010-4809(71)90034-6.

%Program Description
%This program extracts blood vessels from a retina image using Kirsch's Templates.
%Spatial Filtering of the input retina image is done with the Kirsch's
%Templates in different orientations. Followed by thresholding, results in
%the extracted blood vessels. The threshold can be varied to fine tune the
%output.

%The Kirsch operator or Kirsch compass kernel is a non-linear edge detector 
%that finds the maximum edge strength in a few predetermined directions. 
%It is named after the computer scientist Russell A. Kirsch.

% The Kirsch’s template is used for the detection of the
% blood vessels from the retinal images. The Kirsch’s
% operator is the first order derivative which is used for edge
% enhancement and detection. It finds the maximum edge
% strength in a few preset directions. 

function bloodVessels = VesselExtract(inImg, threshold, direction, indVert, indHor)

if nargin < 3
    direction = 'all';
    indVert = [];
    indHor = [];
end %if nargin

%direction: vertical, horizontal

%Kirsch's Templates
h1=[5 -3 -3;
    5  0 -3;
    5 -3 -3]/15;
h2=[-3 -3 5;
    -3  0 5;
    -3 -3 5]/15;
h3=[-3 -3 -3;
     5  0 -3;
     5  5 -3]/15;
h4=[-3  5  5;
    -3  0  5;
    -3 -3 -3]/15;
h5=[-3 -3 -3;
    -3  0 -3;
     5  5  5]/15;
h6=[ 5  5  5;
    -3  0 -3;
    -3 -3 -3]/15;
h7=[-3 -3 -3;
    -3  0  5;
    -3  5  5]/15;
h8=[ 5  5 -3;
     5  0 -3;
    -3 -3 -3]/15;

% figure,
% imshow(inImg,[])

%pad
inImgPad = padarray(inImg, [2 2], 'symmetric');

% figure,
% imshow(inImgPad,[])

%Spatial Filtering by Kirsch's Templates
t{1}=filter2(h1, inImgPad);
t{2}=filter2(h2, inImgPad);
t{3}=filter2(h3, inImgPad);
t{4}=filter2(h4, inImgPad);
t{5}=filter2(h5, inImgPad);
t{6}=filter2(h6, inImgPad);
t{7}=filter2(h7, inImgPad);
t{8}=filter2(h8, inImgPad);

% bloodVessels=zeros(s(1),s(2));
% temp=zeros(1,8);

%

% for i=1:s(1)
%     for j=1:s(2)
%         temp(1)=t1(i,j);temp(2)=t2(i,j);temp(3)=t3(i,j);temp(4)=t4(i,j);
%         temp(5)=t5(i,j);temp(6)=t6(i,j);temp(7)=t7(i,j);temp(8)=t8(i,j);
%         
%         %select based on direction
%         if strcmp(direction, 'vertical')
%             temp = [temp(1) temp(2)];
%         end %if strcmp
%         
%         if strcmp(direction, 'horizontal')
%             temp = [temp(5) temp(6)];
%         end %if strcmp
%         
%         if(max(temp)>threshold)
%             bloodVessels(i,j)=max(temp);
%         end
%     end
% end

allResponses = zeros(size(inImgPad,1), size(inImgPad,2), 8);

if strcmp(direction, 'all')
    indConsider = 1 : 8;
end %if strcmp

if strcmp(direction, 'vertical')
    %indConsider = [1 2 3 4 7 8];
    indConsider = indVert;
end %if strcmp

if strcmp(direction, 'horizontal')
    %indConsider = [5 6 3 4 7 8];
    indConsider = indHor;
end %if strcmp

for i = indConsider
    allResponses(:,:,i) = t{i};
end %for i
%max value across third dimension (different filter responses)
bloodVessels = max(allResponses, [], 3); 
%thresholding
bloodVessels(bloodVessels < threshold) = 0;

% figure,
% imshow(bloodVessels,[])

%crop
bloodVessels = imcrop(bloodVessels, [3 3 size(inImg,2)-1 size(inImg,1)-1]);


