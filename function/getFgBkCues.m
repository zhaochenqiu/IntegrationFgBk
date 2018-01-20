function [re_fgimg re_bkcues re_model re_bkimg re_objinfo re_showimg re_H] = getFgCues(img_cur,model)

% 不行这个错的，前景线索和背景线索是不同的图像

% load the algorithms parameter
global g_template num_multi num_factor threshold_dis g_disRscFgCues;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% captured the background model
mus     = model{1};
sigmas  = model{2};
weights = model{3};


% capturing the sift features
convimg_cur = imfilter(img_cur,g_template);

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
[H_full src tar index_full] = getHomography_ransac(X_cur,X_pre,g_disRscFgCues);


bkobjinfo = features_cur(:,index_full);





global g_rangeAligFg g_rangeAligBk;
% XXX change the code from here
% map = getMapRange_native(grayimg_cur,bkimg,H_full,g_rangeAligFg);



map = getMapRange_single_op(grayimg_cur,bkimg,H_full,g_rangeAligFg);




% aliimg_map  = aligmentImg_byMap(bkimg,map);
% aliimg_h    = aligmentImg_zcq(bkimg,H_full);

% subimg_map  = abs(aliimg_map - grayimg_cur);
% subimg_h    = abs(aliimg_h - grayimg_cur);


mus_res     = abs(mus - mus) - 1;
sigmas_res  = abs(sigmas - sigmas) - 1;
weights_res = abs(weights - weights) - 1;

aligmentImg_byMap_c(mus,mus_res,map);
aligmentImg_byMap_c(sigmas,sigmas_res,map);
aligmentImg_byMap_c(weights,weights_res,map);

mus = mus_res;
sigmas = sigmas_res;
weights = weights_res;

% mus         = aligmentImg_byMap(mus,map);
% sigmas      = aligmentImg_byMap(sigmas,map);
% weights     = aligmentImg_byMap(weights,map);



%bkimg = getBestBkImage(mus,weights);

index = map(:,:,1) < 0;






threshold = 0.3;

[compare fgimg similary] = getFgImage(grayimg_cur,mus,sigmas,weights,threshold);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);

fgimg(index) = 0;

% oldbkimg = getBestBkImage(mus,weights);
% oldweights = weights;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row_t column_t byte_t] = size(mus);

tempimg = mus(:,:,1);
tempimg(index) = grayimg_cur(index);
mus(:,:,1) = tempimg;

for i = 2:byte_t
    tempimg = mus(:,:,i);
    tempimg(index) = 0;
    mus(:,:,i) = tempimg;
end

tempimg = sigmas(:,:,1);
tempimg(index) = 10;
sigmas(:,:,1) = tempimg;

for i = 2:byte_t
    tempimg = sigmas(:,:,i);
    tempimg(index) = 0;
    sigmas(:,:,i) = tempimg;
end


tempimg = weights(:,:,1);
tempimg(index) = 1;
weights(:,:,1) = tempimg;

for i = 2:byte_t
    tempimg = weights(:,:,i);
    tempimg(index) = 0;
    weights(:,:,i) = tempimg;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
aftbkimg = getBestBkImage(mus,weights);

subimg = abs(oldbkimg - aftbkimg);

scalevalue = 100;

displayMatrixImage(1,4,3,oldbkimg,aftbkimg,subimg,grayimg_cur,indeximg,img_cur,...
                        oldweights(:,:,1) * scalevalue, oldweights(:,:,2) * scalevalue, oldweights(:,:,3) *scalevalue, ...
                        weights(:,:,1) *scalevalue, weights(:,:,2) * scalevalue, weights(:,:,3)*scalevalue)

input('pause')
%}


re_objinfo = bkobjinfo';

re_showimg = showObjInfo(fgimg,bkobjinfo');

re_fgimg = fgimg;

re_model = {mus,sigmas,weights};

re_bkimg = getBestBkImage(mus,weights);

re_H     = H_full;















[labels_img, numlabels] = slicmex(uint8(convimg_cur),num_multi,num_factor);

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

minnum = 0;
maxnum = numlabels;

store_objinfo   = [];


global g_disRscBkCues;

minnum = 0;
% transform image in different super pixels
for label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

%    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);


    % [H src tar ok] = getHomography_ransac(tempx_cur,tempx_pre,threshold_disbk);\
    [H src tar ok] = getHomography_ransac(tempx_pre,tempx_cur,g_disRscBkCues);

    objinfo = tempf_cur(:,ok);


    if sum(ok) < 10 
    else
        store_objinfo = [store_objinfo objinfo];
    end

%    store_list = [store_list label];
%    store_transform = {store_transform{:}, H};
end

re_bkcues = store_objinfo';








