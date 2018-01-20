function [re_bkimg re_fgimg] = updateBkImg_IFB(grayimg_cur,bkimg,simimg,model,H)

% H is used to make IFB faster.

global g_thrFgSeg g_thrBkUpd g_template;

re_fgimg = simimg;
index = re_fgimg > g_thrFgSeg*255;

re_fgimg(index) = 255;
index = ~index;
re_fgimg(index) = 0;


re_bkimg = bkimg;

%
%bkimg_gmm = getBestBkImage(model{1},model{3});
%
%
%
%global g_rangeAligFg g_rangeAligBk;
%map = getMapRange_single_op(grayimg_cur,bkimg,H,g_rangeAligBk);
%
%
%bkimg_alig = abs(bkimg - bkimg) - 1;
%aligmentImg_byMap_c(bkimg,bkimg_alig,map);
%
%
%
%% 边界问题前景会被冲掉
%tempimg = simimg;
%index = tempimg > g_thrBkUpd*255;
%bkimg_alig(index) = bkimg_gmm(index);
%
%
%index = map(:,:,1) < 0;
%bkimg_alig(index) = grayimg_cur(index);
%
%
%re_bkimg = bkimg_alig;
%
