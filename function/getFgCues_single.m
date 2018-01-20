function [re_fgimg re_model re_bkimg re_objinfo re_showimg] = getFgCues(img_cur,model)

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

bkobjinfo = features_cur(:,index_full);


% XXX change the code from here
map = getMapRange_single(grayimg_cur,bkimg,H_full);

% aliimg_map  = aligmentImg_byMap(bkimg,map);
% aliimg_h    = aligmentImg_zcq(bkimg,H_full);

% subimg_map  = abs(aliimg_map - grayimg_cur);
% subimg_h    = abs(aliimg_h - grayimg_cur);

mus         = aligmentImg_byMap(mus,map);
sigmas      = aligmentImg_byMap(sigmas,map);
weights     = aligmentImg_byMap(weights,map);


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

threshold = 0.3;

[compare fgimg similary] = getFgImage(grayimg_cur,mus,sigmas,weights,threshold);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);

re_objinfo = bkobjinfo';

re_showimg = showObjInfo(fgimg,bkobjinfo');

re_fgimg = fgimg;

re_model = {mus,sigmas,weights};

re_bkimg = getBestBkImage(mus,weights);
