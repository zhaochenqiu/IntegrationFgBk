function re_model = getCues_Mix(img_cur,model,H_full,compare)

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


global threshold_range;
map = getMapRange_single_op(grayimg_cur,bkimg,H_full,threshold_range);

mus         = aligmentImg_byMap(mus,map);
sigmas      = aligmentImg_byMap(sigmas,map);
weights     = aligmentImg_byMap(weights,map);

[mus sigmas weights] = reInitiaModel(img_cur,mus,sigmas,weights);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);

re_model    = {mus,sigmas,weights};
