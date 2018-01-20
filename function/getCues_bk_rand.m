function [re_fgcues re_bkcues re_H re_model] = getCues_model2img_img2model_bk(img_cur,model)

% this function is based on getCues_model2img_img2model_bk


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


% [labels_img, numlabels] = slicmex(uint8(img_cur),num_multi,num_factor);
% [labels_img, numlabels, labels] = segmentImg_bin(img_cur,log(num_multi)/log(2));
[labels_img, numlabels, labels] = segmentImg_rand(img_cur,num_multi);





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

%minnum = min(label_list);
%maxnum = max(label_list);

% minnum = min(min(labels_img));
% maxnum = max(max(labels_img));

minnum = 0;
maxnum = numlabels;

store_list      = zeros(1,maxnum);
store_transform = cell(1,maxnum);
store_objinfo   = [];

for i = 1:maxnum
    store_transform{i} = H_full;
end



minnum = 0;
% transform image in different super pixels
for label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);

    H = H_full;

    % [H src tar ok] = getHomography_ransac(tempx_cur,tempx_pre,threshold_disbk);\
    [H src tar ok] = getHomography_ransac(tempx_pre,tempx_cur,threshold_disbk);


    objinfo = tempf_cur(:,ok);

    [row_t column_t] = size(H);

    if sum(ok) < 10 
        H = H_full;
    else
        store_objinfo = [store_objinfo objinfo];
    end

    store_list(label + 1) = label;
    store_transform{label + 1} = H;
%    store_list = [store_list label];
%    store_transform = {store_transform{:}, H};
end


global range_multi;
map_model2img = getMap_src2tar(bkimg,grayimg_cur,store_list,store_transform,labels_img,range_multi,H_full);


mus_bk      = aligMap_src2tar(mus,map_model2img);
sigmas_bk   = aligMap_src2tar(sigmas,map_model2img);
weights_bk  = aligMap_src2tar(weights,map_model2img);

[mus_bk sigmas_bk weights_bk] = reInitiaModel(img_cur,mus_bk,sigmas_bk,weights_bk);


global threshold_gmm;


[compare_bk fgimg_bk similary_bk] = getFgImage(grayimg_cur,mus_bk,sigmas_bk,weights_bk,threshold_gmm);

[mus_bk sigmas_bk weights_bk] = updateBkImage(grayimg_cur,mus_bk,sigmas_bk,weights_bk,compare_bk);



re_fgcues   = fgimg_bk;
re_bkcues   = store_objinfo';
re_H        = H_full;
re_model  = {mus_bk,sigmas_bk,weights_bk};
