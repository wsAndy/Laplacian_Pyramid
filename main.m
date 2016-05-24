clear all; close all; clc;

img=double(rgb2gray(imread('after.jpg')));
figure;
imshow(uint8(img));
title('original');

w=1/256*[1  4  6  4 1; 
         4 16 24 16 4;
        6 24 36 24 6;
        4 16 24 16 4;
        1 4  6  4 1];

imgn{1}=img;

for i=2:5                                     %采用拉普拉斯核滤波，下采样
   imgn{i}=imfilter(imgn{i-1},w,'replicate'); % 在假设边界之外的像素点与最近的像素点一致
   imgn{i}=imgn{i}(1:2:size(imgn{i},1)-1,1:2:size(imgn{i},2)-1); %i-1级近似  最后-1 为了之后两倍调整大小时不会越界
end

% 相邻图像之间可能存在不满足两倍的问题，下面将他们的关系完全统一为上下之间行列差别为两倍的关系
       
for i=5:-1:2        %调整图像大小, 由于奇数偶数的问题，边缘的一些像素有丢失，也是为了可以得到 “预测残差”
   imgn{i-1}=imgn{i-1}(1:2*size(imgn{i},1),1:2*size(imgn{i},2)); 
end

 for i=1:4          %获得残差图像，i级预测残差
    imgn{i}=imgn{i}-wsexpand(imgn{i+1},w);     
 end
 
 figure;
 for i = 1:4
     subplot(2,2,i);
     imshow(imgn{i});
     xlabel(['第',num2str(i),'层图的预测残差图']);
 end
 
for i=4:-1:1        %残差图像重构原图像
    imgn{i}=imgn{i}+wsexpand(imgn{i+1},w);
end

figure;
imshow(uint8(imgn{1}));
title('After Processing Image');

[m,n] = size(img);
[Fsim,Fsimc] = FeatureSIM(uint8(img),reshape(uint8(imgn{1}),m,n));
Fsim
% for i =1:4
%     subplot(2,2,i);
%     imshow(uint8(imgn{i}));
%     xlabel(['缩小',num2str(4^(i-1)),'倍']);
% end