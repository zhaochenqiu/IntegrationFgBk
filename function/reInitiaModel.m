function [re_mus re_sigmas re_weights] = reInitiaModel(img_cur,mus,sigmas,weights)

[row_img column_img byte_img] = size(img_cur);


if byte_img == 1
    grayimg_cur = img_cur;
else
    global template;

%    convimg_cur = zeros(row_img,column_img,byte_img) + img_cur;
%    convolution_c(convimg_cur,img_cur,template);

    convimg_cur = imfilter(img_cur,template);

    grayimg_cur = grayImage(convimg_cur);
end

bkimg = getBestBkImage(mus,weights);
index = bkimg < 0;

tempimg = mus(:,:,1);
tempimg(index) = grayimg_cur(index);
mus(:,:,1) = tempimg;

tempimg = mus(:,:,2);
tempimg(index) = 0;
mus(:,:,2) = tempimg;

tempimg = mus(:,:,3);
tempimg(index) = 0;
mus(:,:,3) = tempimg;


tempimg = sigmas(:,:,1);
tempimg(index) = 10;
sigmas(:,:,1) = tempimg;

tempimg = sigmas(:,:,2);
tempimg(index) = 0;
sigmas(:,:,2) = tempimg;

tempimg = sigmas(:,:,3);
tempimg(index) = 0;
sigmas(:,:,3) = tempimg;


tempimg = weights(:,:,1);
tempimg(index) = 1;
weights(:,:,1) = tempimg;

tempimg = weights(:,:,2);
tempimg(index) = 0;
weights(:,:,2) = tempimg;

tempimg = weights(:,:,3);
tempimg(index) = 0;
weights(:,:,3) = tempimg;

re_mus = mus;
re_sigmas = sigmas;
re_weights = weights;
