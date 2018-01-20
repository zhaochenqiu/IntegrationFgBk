function [re_mus re_sigmas re_weights] = initializeGMM(img);

[row_img column_img byte_img] = size(img);

global g_template;
%convimg = zeros(row_img,column_img,byte_img) + img;
%convolution_c(convimg,img,template);

convimg = imfilter(img,g_template,'replicate');

grayimg = grayImage(convimg);
% grayimg = grayImage_fake(convimg);


global num_model;
mus     = zeros(row_img,column_img,num_model);
sigmas  = zeros(row_img,column_img,num_model);
weights = zeros(row_img,column_img,num_model);

mus(:,:,1)      = grayimg;
sigmas(:,:,1)   = 10;
weights(:,:,1)  = 1;

re_mus = mus;
re_sigmas = sigmas;
re_weights = weights;
