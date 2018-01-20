function  re_model = strongerUpdateBk(img_cur,model,simimg)

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
[H_full src tar index_full] = getHomography_ransac(X_cur,X_pre,threshold_dis);


global threshold_range;
map = getMapRange_single_op(grayimg_cur,bkimg,H_full,threshold_range);


mus         = aligmentImg_byMap(mus,map);
sigmas      = aligmentImg_byMap(sigmas,map);
weights     = aligmentImg_byMap(weights,map);

[mus sigmas weights] = reInitiaModel(img_cur,mus,sigmas,weights);

global stronger_thr;
maskimg = thresholdImage(simimg,stronger_thr*255);

global num_model;
for i = 1:row_img
    for j = 1:column_img
        if maskimg(i,j) ~= 255
            for q = 1:num_model
                mus(i,j,q) = grayimg_cur(i,j);
            end
        end
    end
end


re_model    = {mus,sigmas,weights};
