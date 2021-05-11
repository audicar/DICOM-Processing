% biotron week 9
%
clear;
clc;
clf;
%% Exercise 1
disp("Exercise 1");
filename = "heart001.IMA";
info = dicominfo(filename);
X = dicomread(info);
fprintf("1a. Imaging modality: %s\n",info.Modality);

%Ex1.2
disp("2a. image position");
disp(info.ImagePositionPatient);
disp("2a. image orientation");
fprintf("%f\n",info.ImageOrientationPatient);
disp("2b. Pixel spacing:");
disp(info.PixelSpacing);
%Ex1.2c
pos = info.ImagePositionPatient;
ori = info.ImageOrientationPatient;
sp = info.PixelSpacing; 
M = [ori(1)*sp(1),ori(4)*sp(2),0,pos(1);
    ori(2)*sp(1),ori(5)*sp(2),0,pos(2);
    ori(3)*sp(1),ori(6)*sp(2),0,pos(3);
        0,      0,      0,  1];
disp("M = ");
disp(M);

%Ex1.3
fprintf("3a. Repetition Time:%f\n",info.RepetitionTime);
rep = info.RepetitionTime;
%Ex1.4
P = M*[i;j;0;1];
%I = mat2gray(M);
figure(1);
imshow(X,[]);

%

video = VideoWriter(fullfile(pwd,'myvideo.avi')); %create the video object

video.FrameRate = 1/(rep/1000);
open(video); 
for i=1:25 
    name = sprintf("heart%03.0f.IMA",i);
    img = double(dicomread(fullfile(pwd,"heart021",name)))/(2^16);
    img = img/max(img,[],'all');
    info_temp2(i) = dicominfo(filename);
    %images{i} = dicomread(info_temp2(i));
  writeVideo(video,img); %write the image to file
end
close(video); %close the file

%% Exercise 3
% commenting the below code out so I don't have to re-draw again
%  for(i = 1:25)
%      raw = (mat2gray(images{i})); 
%     imshow(raw);
%     h = imfreehand;
%     %h = drawassisted(raw);
%     bw{i} = createMask(h);
%  end

bw = load('bww.mat');
info_temp = load('info_tempp.mat');
for(i = 1:25)
    pixelSpacing = info_temp2(i).PixelSpacing;
    raw2 = bw.bw(i);
    raw = raw2{1,1};
    pixels(i) = sum(sum(raw))*pixelSpacing(1)*pixelSpacing(2); 
    imshow(raw);
end

t = [1:rep:25*rep];
figure(2);
plot(t, pixels);
grid on;
ylabel("Area (mm^2)");
xlabel("Time (ms)");
title("Change in area of right atrium");

