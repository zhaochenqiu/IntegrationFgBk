function [re_fgimg re_model re_H re_convimg_cur re_f_cur re_d_cur] = getFgCues(img_cur,model)



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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这几个是为了加速用的所以特别对待                  %
re_convimg_cur = convimg_cur;                       %
re_f_cur = f_cur;                                   %
re_d_cur = d_cur;                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





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



global g_rangeAligFg g_rangeAligBk;
% XXX change the code from here
map = getMapRange_single_op(grayimg_cur,bkimg,H_full,g_rangeAligFg);






[row_t column_t byte_t] = size(mus);

temp_mus        = mus;
temp_sigmas     = sigmas;
temp_weights    = weights;

mus     = zeros(row_t,column_t,byte_t) - 1;
sigmas  = zeros(row_t,column_t,byte_t) - 1;
weights = zeros(row_t,column_t,byte_t) - 1;

aligmentImg_byMap_c(temp_mus,       mus,    map);
aligmentImg_byMap_c(temp_sigmas,    sigmas, map);
aligmentImg_byMap_c(temp_weights,   weights,map);



index = map(:,:,1) < 0;



% threshold = 0.3;
global g_gmmFgThreshold;

[compare fgimg similary] = getFgImage(grayimg_cur,mus,sigmas,weights,g_gmmFgThreshold);

[mus sigmas weights] = updateBkImage(grayimg_cur,mus,sigmas,weights,compare);




fgimg(index) = 0;



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



re_fgimg = fgimg;

re_model = {mus,sigmas,weights};

re_H     = H_full;


