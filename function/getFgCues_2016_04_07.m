function [re_fgimg re_model re_bkimg re_showimg] = getFgCues(img_cur,model)


% 这个是可以用的，但是没有随机校正，因此暂时放弃，修改，而且只一整块的，浪费了大量的运算
% 新版本目的是重用，并解决这个问题

% load the algorithms parameter
global template num_multi num_factor threshold_dis;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% captured the background model
mus     = model{1};
sigmas  = model{2};
weights = model{3};


% capturing the sift features
convimg_cur = zeros(row_img,column_img,byte_img) + img_cur;
convolution_c(convimg_cur,img_cur,template);

bkimg       = getBestBkImage(mus,weights);
grayimg_pre = bkimg;
grayimg_cur = grayImage(convimg_cur);

uimg_pre = uint8(grayimg_pre);
uimg_cur = uint8(grayimg_cur);

singleimg_pre = im2single(uimg_pre);
singleimg_cur = im2single(uimg_cur);

[f_pre, d_pre] = vl_sift(singleimg_pre);
[f_cur, d_cur] = vl_sift(singleimg_cur);


% matching the sift features
[matches, scores] = vl_ubcmatch(d_pre,d_cur);

X_pre = f_pre(1:2,matches(1,:));
X_pre(3,:) = 1;
features_pre = f_pre(:,matches(1,:));

X_cur = f_cur(1:2,matches(2,:));
X_cur(3,:) = 1;
features_cur = f_cur(:,matches(2,:));


% captured the homography between bkimg and img_cur
[H_full src tar index_full] = getHomography_ransac(X_cur,X_pre,threshold_dis);

ali_bkimg = aligmentImg_zcq(bkimg,H_full);

subimg_full = abs(ali_bkimg - grayImage(img_cur));

siftfeatures_cur = features_cur(:,index_full);

showobjimg = showObjInfo(subimg_full,siftfeatures_cur');



%{
global g_displayMatrixImage
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,2,ali_bkimg,grayImage(img_cur),subimg_full,showobjimg)
%}

[labels_img, numlabels] = slicmex(uint8(img_cur),num_multi,num_factor);


% get the size of matches
[row_sift column_sift] = size(matches);

label_list = zeros(1,column_sift);

% get the label list for classifying the sift features in superpixel
for i = 1:column_sift
    pos_x = round(X_cur(1,i));
    pos_y = round(X_cur(2,i));

    pos_x = max([pos_x 1]);
    pos_y = max([pos_y 1]);
    pos_x = min([pos_x column_img]);
    pos_y = min([pos_y row_img]);

    label = labels_img(pos_y,pos_x);
    label_list(i) = label;
end

minnum = min(label_list);
maxnum = max(label_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the value is being remove
%{
list_value = [];
list_all_pre = [];
list_all_cur = [];

list_mea_pre = [];
list_mea_cur = [];

re_fgimg = zeros(row_img,column_img,byte_img);
re_fgimg(:,:,1) = 255;
[row_t column_t] = size(features_pre);
count = 1;
list_H = {};
lineimg = img_cur;

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aligimg_multi = abs(bkimg - bkimg) - 1;

srcmus      = mus;
srcsigmas   = sigmas;
srcweights  = weights;

bkobjinfo = [];

% transform image in different super pixels
for label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);

    [H src tar ok] = getHomography_ransac(tempx_cur,tempx_pre,threshold_dis);
    
    drawf = tempf_cur(:,ok);

    sumvalue = sum(ok)
    if sum(ok) < 10
        % there are not enough point for capturing homography
        H = H_full;
        % input('replace the H by H_full')
    else
        bkobjinfo = [bkobjinfo ; drawf'];
    end


    ali_bkimg = aligmentImg_zcq(bkimg,H);

    showali_bkimg = showObjInfo(ali_bkimg,drawf');

    alimus      = aligmentImg_zcq(srcmus,H);
    alisigmas   = aligmentImg_zcq(srcsigmas,H);
    aliweights  = aligmentImg_zcq(srcweights,H);

    mus     = giveImg_byLabels(mus,alimus,labels_img,label);
    sigmas  = giveImg_byLabels(sigmas,alisigmas,labels_img,label);
    weights = giveImg_byLabels(weights,aliweights,labels_img,label);

%    tempbkimg = getBestBkImage(mus,weights);

%    displayMatrixImage(1,2,2,)

    index = labels_img == label;
    aligimg_multi(index) = ali_bkimg(index);


    % XXX
    % these var is utilized to show middle result
    subimg1 = abs(ali_bkimg - grayImage(img_cur));

    displayMatrixImage(label,2,2,ali_bkimg,img_cur,subimg1,showali_bkimg);
 %   displayMatrixImage(1,2,2,labels_img*10,aligimg_multi,showali_bkimg,tempsubbk)
end

grayimg_cur = grayImage(convimg_cur);
%sumimg = sum(aligimg_multi,3);
%index = sumimg < 0;
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  bkimg = getBestBkImage(mus,weights);

threshold = 0.3;

[compare fgimg similary] = getFgImage(grayimg_cur,mus,sigmas,weights,threshold);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);

% displayMatrixImage(1,1,1,fgimg)

% input('end of program')

re_showimg = showObjInfo(fgimg,bkobjinfo);

re_fgimg = fgimg;

re_model = {mus,sigmas,weights};

re_bkimg = getBestBkImage(mus,weights);
