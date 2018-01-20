function [re_fgcues re_bkcues re_H re_model] = getCues_model2img_img2model_bk(img_cur,model)

% this function is based on getCues_model2img_img2model_bk

% load the algorithms parameter
global template num_multi num_factor num_scale threshold_dis threshold_disbk;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

convimg_cur = imfilter(img_cur,template);

grayimg_cur = grayImage(convimg_cur);


[mus_bk sigmas_bk weights_bk] = initializeGMM(img_cur);

global threshold_gmm;


[compare_bk fgimg_bk similary_bk] = getFgImage(grayimg_cur,mus_bk,sigmas_bk,weights_bk,threshold_gmm);

[mus_bk sigmas_bk weights_bk] = updateBkImage(grayimg_cur,mus_bk,sigmas_bk,weights_bk,compare_bk);


re_fgcues   = fgimg_bk;
re_bkcues   = [];
re_H        = [];
re_model  = {mus_bk,sigmas_bk,weights_bk};
