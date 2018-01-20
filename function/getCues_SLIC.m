% function [re_fgcues re_bkcues re_H re_model] = getCues_model2img_SLIC(img_cur,model)
function [re_fgcues_bk re_bkcues_bk re_model_bk ...
          re_fgcues_fg re_bkcues_fg re_model_fg ...
          re_fgcues_fg_up re_bkcues_fg_up re_model_fg_up] = getCues_model2img_SLIC(img_cur,model_bk,model_fg,model_fg_up)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function is based on getCues_model2img_img2model_bk                                          %
                                                                                                    %
% load the algorithms parameter
global template num_multi num_factor num_scale threshold_dis threshold_disbk;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% captured the background model
mus     = model_bk{1};
sigmas  = model_bk{2};
weights = model_bk{3};


% capturing the sift features
convimg_cur = zeros(row_img,column_img,byte_img) + img_cur;
convolution_c(convimg_cur,img_cur,template);

bkimg       = getBestBkImage(mus,weights);
grayimg_pre = bkimg;
grayimg_cur = grayImage(convimg_cur);
% grayimg_cur = grayImage_fake(convimg_cur);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uimg_pre = uint8(grayimg_pre);                              %% 1.7s
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% captured the homography between bkimg and img_cur
[H_full src tar index_full] = getHomography_ransac(X_pre,X_cur,threshold_dis);
[H_full_fg src_fg tar_fg index_full_fg] = getHomography_ransac(X_cur,X_pre,threshold_dis);



% [labels_img, numlabels] = slicmex(uint8(img_cur),num_multi,num_factor);

[labels_img numlabels] = segmentImg_SLIC_rand(uint8(img_cur),num_multi,num_factor,num_scale);

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

store_list      = zeros(1,maxnum);
store_transform = cell(1,maxnum);
store_objinfo   = [];


store_list_fg      = zeros(1,maxnum);
store_transform_fg = cell(1,maxnum);
store_objinfo_fg   = [];

for i = 1:maxnum
    store_transform{i} = H_full;
    store_transform_fg{i} = H_full_fg;
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
    [H_fg src_fg tar_fg ok_fg] = getHomography_ransac(tempx_cur,tempx_pre,threshold_disbk);


    objinfo = tempf_cur(:,ok);

    [row_t column_t] = size(H);

    if sum(ok) < 10 
        H = H_full;
    else
        store_objinfo = [store_objinfo objinfo];
    end

    store_list(label + 1) = label;
    store_transform{label + 1} = H;


    %--------------------------------------------------------------------
    objinfo_fg = tempf_cur(:,ok_fg);

    [row_t column_t] = size(H_fg);

    if sum(ok_fg) < 10 
        H_fg = H_full_fg;
    else
        store_objinfo_fg = [store_objinfo_fg objinfo_fg];
    end

    store_list_fg(label + 1) = label;
    store_transform_fg{label + 1} = H_fg;
end
                                                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the cues bk
global range_multi;
map_model2img = getMap_src2tar(bkimg,grayimg_cur,store_list,store_transform,labels_img,range_multi,H_full);


mus_bk      = aligMap_src2tar(mus,map_model2img);
sigmas_bk   = aligMap_src2tar(sigmas,map_model2img);
weights_bk  = aligMap_src2tar(weights,map_model2img);

[mus_bk sigmas_bk weights_bk] = reInitiaModel(img_cur,mus_bk,sigmas_bk,weights_bk);


global threshold_gmm;


[compare_bk fgimg_bk similary_bk] = getFgImage(grayimg_cur,mus_bk,sigmas_bk,weights_bk,threshold_gmm);

[mus_bk sigmas_bk weights_bk] = updateBkImage(grayimg_cur,mus_bk,sigmas_bk,weights_bk,compare_bk);


re_fgcues_bk    = fgimg_bk;
re_bkcues_bk    = store_objinfo';
re_model_bk     = {mus_bk,sigmas_bk,weights_bk};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the cues fg
store_list = store_list_fg;
store_transform = store_transform_fg;
H_full = H_full_fg;
store_objinfo = store_objinfo_fg;

global range_single;

map_img2model = getMap_tar2src(bkimg,grayimg_cur,store_list,store_transform,labels_img,range_single,H_full);

mus_fg      = aligMap_tar2src(mus,map_img2model);
sigmas_fg   = aligMap_tar2src(sigmas,map_img2model);
weights_fg  = aligMap_tar2src(weights,map_img2model);

[mus_fg sigmas_fg weights_fg] = reInitiaModel(img_cur,mus_fg,sigmas_fg,weights_fg);

global threshold_gmm;

[compare_fg fgimg_fg similary_fg] = getFgImage(grayimg_cur,mus_fg,sigmas_fg,weights_fg,threshold_gmm);

[mus_fg sigmas_fg weights_fg] = updateBkImage(grayimg_cur,mus_fg,sigmas_fg,weights_fg,compare_fg);


re_fgcues_fg   = fgimg_fg;
re_bkcues_fg   = store_objinfo';
re_model_fg = {mus_fg,sigmas_fg,weights_fg};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the cues single fg

global range_single_fg;

map_img2model = getMap_tar2src(bkimg,grayimg_cur,store_list,store_transform,labels_img,range_single_fg,H_full);

mus_fg      = aligMap_tar2src(mus,map_img2model);
sigmas_fg   = aligMap_tar2src(sigmas,map_img2model);
weights_fg  = aligMap_tar2src(weights,map_img2model);

[mus_fg sigmas_fg weights_fg] = reInitiaModel(img_cur,mus_fg,sigmas_fg,weights_fg);

global threshold_gmm;

[compare_fg fgimg_fg similary_fg] = getFgImage(grayimg_cur,mus_fg,sigmas_fg,weights_fg,threshold_gmm);

[mus_fg sigmas_fg weights_fg] = updateBkImage(grayimg_cur,mus_fg,sigmas_fg,weights_fg,compare_fg);



re_fgcues_fg_up   = fgimg_fg;
re_bkcues_fg_up   = store_objinfo';
re_model_fg_up  = {mus_fg,sigmas_fg,weights_fg};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



