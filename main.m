clc; clear; close all;
%I = double(imread('test.jpg'));
I = double(captureWebCam());
[h,w,ch] = size(I);

merkez = struct('x', w/2, 'y', h/2);

height = 100;
width = 200;

figure; 
imshow(uint8(I));
hold on;
rectangle('Position',[merkez.x-width merkez.y-height 2*width 2*height],'EdgeColor','y','LineWidth',2,'Curvature',[.1 .8]);
hold off;

roi_coor = struct('x1',merkez.x-width,'x2',merkez.x+width,'y1',merkez.y-height,'y2',merkez.y+height);

crop_image = crop(I, roi_coor);
figure;
imshow(uint8(crop_image));


%% Detect
det = detect(crop_image,true,roi_coor, I);

if det == 0
    disp('Kýrmýzý ve Mavi tespit edildi!');
elseif det == 1
    disp('Kýrmýzý tespit edildi!');
elseif det == 2
    disp('Mavi testpit edildi!');
else
    disp('Tespit Baþarýsýz!');
end











