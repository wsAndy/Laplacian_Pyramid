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

for i=2:5                                     %����������˹���˲����²���
   imgn{i}=imfilter(imgn{i-1},w,'replicate'); % �ڼ���߽�֮������ص�����������ص�һ��
   imgn{i}=imgn{i}(1:2:size(imgn{i},1)-1,1:2:size(imgn{i},2)-1); %i-1������  ���-1 Ϊ��֮������������Сʱ����Խ��
end

% ����ͼ��֮����ܴ��ڲ��������������⣬���潫���ǵĹ�ϵ��ȫͳһΪ����֮�����в��Ϊ�����Ĺ�ϵ
       
for i=5:-1:2        %����ͼ���С, ��������ż�������⣬��Ե��һЩ�����ж�ʧ��Ҳ��Ϊ�˿��Եõ� ��Ԥ��в
   imgn{i-1}=imgn{i-1}(1:2*size(imgn{i},1),1:2*size(imgn{i},2)); 
end

 for i=1:4          %��òв�ͼ��i��Ԥ��в�
    imgn{i}=imgn{i}-wsexpand(imgn{i+1},w);     
 end
 
 figure;
 for i = 1:4
     subplot(2,2,i);
     imshow(imgn{i});
     xlabel(['��',num2str(i),'��ͼ��Ԥ��в�ͼ']);
 end
 
for i=4:-1:1        %�в�ͼ���ع�ԭͼ��
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
%     xlabel(['��С',num2str(4^(i-1)),'��']);
% end