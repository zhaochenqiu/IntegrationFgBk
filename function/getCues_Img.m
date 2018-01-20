function [re_fgcues re_bkcues re_model re_H] = getCues_Img(img_cur,model)

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
% map = getMapRange_single_op(bkimg,grayimg_cur,H_full,threshold_range);
map = getMapNative_single(bkimg,H_full);

aligimg_cur = aligmentImg_byMap(grayimg_cur,map);

% full the aligimg_cur
index = aligimg_cur < 0;
aligimg_cur(index) = bkimg(index);


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

store_list      = [];
store_transform = {};
store_objinfo   = [];

% transform image in different super pixels
for label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);

    [H src tar ok] = getHomography_ransac(tempx_cur,tempx_pre,threshold_disbk);

    objinfo = tempf_cur(:,ok);

    if sum(ok) < 10
        H = H_full;
    else
        store_objinfo = [store_objinfo objinfo];
    end

    store_list = [store_list label];
    store_transform = {store_transform{:}, H};
end

global threshold_gmm;

[compare fgimg similary] = getFgImage(aligimg_cur,mus,sigmas,weights,threshold_gmm);

[mus sigmas weights] = updateBkImage(aligimg_cur,mus,sigmas,weights,compare);


[tempH src tar index_full] = getHomography_ransac(X_cur,X_pre,threshold_dis);

% map = getMapRange_single_op(grayimg_cur,bkimg,tempH,threshold_range);
map = getMapNative_single(grayimg_cur,tempH);

re_fgcues   = aligmentImg_byMap(fgimg,map);
re_bkcues   = store_objinfo';
re_model    = {mus,sigmas,weights};
re_H        = H_full;
