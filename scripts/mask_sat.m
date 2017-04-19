function [mask_I]=mask_sat(I1,I2,I3, comb_I)
% This function is used to mask the pixels of any image comb_I; given three
% LDR images I1, I2, I3. If a pixel > 240, in all the three LDR images
% simulateneously, it is called saturated.

% Usage
% I1=imread(['./Set/set_two_1_250.JPG']);
% I2=imread(['./Set/set_two_1_1000.JPG']);
% I3=imread(['./Set/set_two_1_4000.JPG']);
% comb_I=imread(['./Set/set_two_1_1000.JPG']);
% [mask_I]=mask_sat(I1,I2,I3, comb_I);
% figure; imshow(uint8(mask_I));





I_GT=comb_I;


[rows,cols,~]=size(I1);
I1_gray=rgb2gray(I1);   I1_gray=double(I1_gray);
I2_gray=rgb2gray(I2);   I2_gray=double(I2_gray);
I3_gray=rgb2gray(I3);   I3_gray=double(I3_gray);

mask=ones(rows,cols);

for i=1:rows
   for j=1:cols
       if (I1_gray(i,j)>240)&&(I2_gray(i,j)>240)&&(I3_gray(i,j)>240)
           mask(i,j)=0;
       end
   end
end

if (length(size(comb_I))==2)
    I_GT_color=repmat(I_GT,[1 1 3]);
else
    I_GT_color=I_GT;
end

for i=1:rows
   for j=1:cols
      if  mask(i,j)==0
          I_GT_color(i,j,1)=255;
          I_GT_color(i,j,2)=0;
          I_GT_color(i,j,3)=255;
      end
   end
    
end


I_GT_color=double(I_GT_color);
mask_I=I_GT_color;


end
