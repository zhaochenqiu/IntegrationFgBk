


%%  WatershedBaidu.m

clear;close all;clc;

% http://hi.baidu.com/flyingmooding/blog/item/9dff7f60cba422d7e7113ab8.html/cmtid/18bdcf3a5ddd372e97ddd83c

% 例17.6分水岭分割算法
% 2009-11-23 16:35
%       如果图像中的目标物体是连在一起的，则分割起来会更困难，分水岭算法经常用于处理这类问题，
% 通常会取得比较好的效果。分水岭分割算法把图像看成一副“地形图”，其中亮度比较强的地区像素值较大，
% 而比较暗的地区像素比较小，通过寻找“汇水盆地”和“分水岭界限”，对图像进行分割。
% 
% 步骤：
% 
% 1.读取图像
% 
% 2.求取图像的边界，在此基础上可直接应用分水岭分割算法，但效果不佳；
% 
% 3.对图像的前景和背景进行标记，其中每个对象内部的前景像素都是相连的，背景里面的每个像素值都不属于任何目标物体；
% 
% 4.计算分割函数，应用分水岭分割算法的实现
% 
%     注：直接用分水岭分割算法效果并不好，如果在图像中对前景和背景进行标注区别，再应用分水岭算法会取得较好的分割效果。
% 
% 例 步骤：
% 
%% 1.读取图像并求取图像的边界。


rgb = imread('d:/dataset/FBMS_Trainingset/Trainingset/horses01/horses01_0200.jpg');



I = rgb2gray(rgb);%转化为灰度图像
figure; subplot(121)%显示灰度图像
imshow(I)
text(732,501,'Image courtesy of Corel',...
     'FontSize',7,'HorizontalAlignment','right')
hy = fspecial('sobel');%sobel算子
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');%滤波求y方向边缘
Ix = imfilter(double(I), hx, 'replicate');%滤波求x方向边缘
gradmag = sqrt(Ix.^2 + Iy.^2);%求摸
subplot(122); imshow(gradmag,[]), %显示梯度
title('Gradient magnitude (gradmag)')

%% 2. 直接使用梯度模值进行分水岭算法：（往往会存在过的分割的情况，效果不好）

L = watershed(gradmag);%直接应用分水岭算法
Lrgb = label2rgb(L);%转化为彩色图像
figure; imshow(Lrgb), %显示分割后的图像
title('Watershed transform of gradient magnitude (Lrgb)')

%% 3.分别对前景和背景进行标记：本例中使用形态学重建技术对前景对象进行标记，首先使用开操作，开操作之后可以去掉一些很小的目标。

se = strel('disk', 20);%圆形结构元素
Io = imopen(I, se);%形态学开操作
figure; subplot(121)
imshow(Io), %显示执行开操作后的图像
title('Opening (Io)')
Ie = imerode(I, se);%对图像进行腐蚀
Iobr = imreconstruct(Ie, I);%形态学重建
subplot(122); imshow(Iobr), %显示重建后的图像
title('Opening-by-reconstruction (Iobr)')
Ioc = imclose(Io, se);%形态学关操作
figure; subplot(121)
imshow(Ioc), %显示关操作后的图像
title('Opening-closing (Ioc)')
Iobrd = imdilate(Iobr, se);%对图像进行膨胀
Iobrcbr = imreconstruct(imcomplement(Iobrd), ...
    imcomplement(Iobr));%形态学重建
Iobrcbr = imcomplement(Iobrcbr);%图像求反
subplot(122); imshow(Iobrcbr), %显示重建求反后的图像
title('Opening-closing by reconstruction (Iobrcbr)')
fgm = imregionalmax(Iobrcbr);%局部极大值
figure; imshow(fgm), %显示重建后局部极大值图像
title('Regional maxima of opening-closing by reconstruction (fgm)')
I2 = I;
I2(fgm) = 255;%局部极大值处像素值设为255
figure; imshow(I2), %在原图上显示极大值区域
title('Regional maxima superimposed on original image (I2)')
se2 = strel(ones(5,5));%结构元素
fgm2 = imclose(fgm, se2);%关操作
fgm3 = imerode(fgm2, se2);%腐蚀
fgm4 = bwareaopen(fgm3, 20);%开操作
I3 = I;
I3(fgm4) = 255;%前景处设置为255
figure; subplot(121)
imshow(I3)%显示修改后的极大值区域
title('Modified regional maxima')
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%转化为二值图像
subplot(122); imshow(bw), %显示二值图像
title('Thresholded opening-closing by reconstruction')

%% 4. 进行分水岭变换并显示：

D = bwdist(bw);%计算距离
DL = watershed(D);%分水岭变换
bgm = DL == 0;%求取分割边界
figure; imshow(bgm), %显示分割后的边界
title('Watershed ridge lines (bgm)')
gradmag2 = imimposemin(gradmag, bgm | fgm4);%置最小值
L = watershed(gradmag2);%分水岭变换
I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;%前景及边界处置255
figure; subplot(121)
imshow(I4)%突出前景及边界
title('Markers and object boundaries')
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');%转化为伪彩色图像
subplot(122); imshow(Lrgb)%显示伪彩色图像
title('Colored watershed label matrix')
figure; imshow(I), 
hold on
himage = imshow(Lrgb);%在原图上显示伪彩色图像
set(himage, 'AlphaData', 0.3);
title('Lrgb superimposed transparently on original image')






















