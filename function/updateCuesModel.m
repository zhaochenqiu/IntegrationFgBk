function [re_model re_img] = updateCuesModel(img_cur,model)

% load the algorithms parameter
global template num_multi num_factor threshold_dis threshold_disbk;

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
% grayimg_cur = grayImage_fake(convimg_cur);


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
[H_full src tar index_full] = getHomography_ransac(X_pre,X_cur,threshold_dis);

global threshold_range;
map = getMapRange_single_op(bkimg,grayimg_cur,H_full,threshold_range);
% map = getMapNative_single(bkimg,H_full);

aligimg_cur = aligmentImg_byMap(grayimg_cur,map);
% full the aligimg_cur
index = aligimg_cur < 0;
aligimg_cur(index) = bkimg(index);


global threshold_gmm;

[compare fgimg similary] = getFgImage(aligimg_cur,mus,sigmas,weights,threshold_gmm);

[mus sigmas weights] = updateBkImage(aligimg_cur,mus,sigmas,weights,compare);

re_model    = {mus,sigmas,weights};
re_img      = fgimg;
