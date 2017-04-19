% Main file to generate the important figures in the paper: S. Dev, F. M. Savoy, Y. H. Lee, S. Winkler, Design of low-cost, compact and weather-proof whole sky imagers for high-dynamic-range captures, Proc. IEEE International Geoscience and Remote Sensing Symposium (IGARSS), July 2015.

% Camera response curve

clear all; clc;
dirName = ('./Set/');

directory_name=dirName;
dirName = directory_name;
[filenames, exposures, ~] = readDir(dirName);
fprintf('Opening test image\n');

tmp = imread(filenames{1});
numPixels = size(tmp,1) * size(tmp,2);
numExposures = size(filenames,2);

% define lamda smoothing factor
l = 50;
fprintf('Computing weighting function\n');

% precompute the weighting function value for each pixel
weights = [];
for i=1:256
    weights(i) = weight(i,1,256);
end

% load and sample the images
[zRed, zGreen, zBlue, sampleIndices] = makeImageMatrix(filenames, numPixels);
B = zeros(size(zRed,1)*size(zRed,2), numExposures);
fprintf('Creating exposures matrix B\n')
for i = 1:numExposures
    B(:,i) = log(exposures(i));
end

% solve the system for each color channel
fprintf('Solving for red channel\n')
[gRed,lERed]=gsolve(zRed, B, l, weights);
fprintf('Solving for green channel\n')
[gGreen,lEGreen]=gsolve(zGreen, B, l, weights);
fprintf('Solving for blue channel\n')
[gBlue,lEBlue]=gsolve(zBlue, B, l, weights);

fprintf('Computing hdr image\n')
hdrMap = hdr(filenames, gRed, gGreen, gBlue, weights, B);






%%
% Generates Figure 5.

figure;
hold all;

% Image 1
img1_red=zRed(:,1);
exp1_red=zeros(size(img1_red));
[LEN,~]=size(img1_red);

for t=1:LEN
   exp1_red(t,1)=gRed(img1_red(t,1)+1,1);
end

scatter(img1_red(1:2:200,:),exp1_red(1:2:200,:),'d','MarkerEdgeColor','r');


% Image 2
img2_red=zRed(:,2);
exp2_red=zeros(size(img2_red));

for t=1:LEN
   exp2_red(t,1)=gRed(img2_red(t,1)+1,1);
end

scatter(img2_red(1:2:200,:),exp2_red(1:2:200,:),'s','MarkerEdgeColor','c');


% Image 3
img3_red=zRed(:,3);
exp3_red=zeros(size(img3_red));

for t=1:LEN
   exp3_red(t,1)=gRed(img3_red(t,1)+1,1);
end

scatter(img3_red(1:2:200,:),exp3_red(1:2:200,:),'+','MarkerEdgeColor','b');


legend('+1 EV','-1 EV','-3 EV','Location','southeast');
scatter(img2_red(1:2:200,:),exp2_red(1:2:200,:),'s','MarkerEdgeColor','c');
grid on;
box on;



%%
% Generates Figure 6.

input_image=imread([dirName,'set_two_1_1000.JPG']);

I1=imread([dirName,'set_two_1_250.JPG']);
I2=imread([dirName,'set_two_1_1000.JPG']);
I3=imread([dirName,'set_two_1_4000.JPG']);

I_crop=imcrop(input_image,[1600,900,500,500]); 

% Shows cropped version of Auto-exposure image
figure; 
imshow(I_crop);

[I_msk]=mask_sat(I2,I2,I2, I2);
I_msk2=imcrop(I_msk,[1600,900,500,500]); 

% Shows cropped version of Auto-exposure image with saturated component
figure; 
imshow(uint8(I_msk2));


RGB=tonemap(hdrMap,'AdjustSaturation',1.2);
HDR_crop=imcrop(RGB,[1600,900,500,500]); 

% Shows cropped version of HDR tonemapped image
figure; 
imshow(HDR_crop);

[hd_msk]=mask_sat(RGB,RGB,RGB, RGB);
hd_msk2=imcrop(hd_msk,[1600,900,500,500]); 

% Shows cropped version of HDR tonemapped image with saturated component
figure; 
imshow(uint8(hd_msk2));


% With blocker
IB=imread('/home/soumya/Dropbox/MATLAB/HDR_input/IGARSS/I_block.JPG');
IB_crop=imcrop(IB,[1600,900,500,500]); 
[IB_msk]=mask_sat(IB,IB,IB, IB);
IB_msk2=imcrop(IB_msk,[1600,900,500,500]); 

% Shows cropped version of sun-blocker image with saturated component
figure; 
imshow(uint8(IB_msk2));

%%

% Generate Figure 6 (Top row)
% Draw rectangles
auto_tec=imread([dirName,'set_two_1_1000.JPG']);

% Auto exposure
figure;
imshow(auto_tec); hold on;
rectangle('Position',[1600,900,500,500],'EdgeColor','w') ;

IB=imread('/home/soumya/Dropbox/MATLAB/HDR_input/IGARSS/I_block.JPG');

% Sun blocker
figure;
imshow(IB); hold on;
rectangle('Position',[1600,900,500,500],'EdgeColor','w') ;

% HDR Tonemapped image
figure;
imshow(RGB); hold on;
rectangle('Position',[1600,900,500,500],'EdgeColor','w') ;

%%


