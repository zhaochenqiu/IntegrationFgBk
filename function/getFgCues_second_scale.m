function [re_fgimg re_model] = getFgCues(img_cur,model)

% load the algorithms parameter
global template num_multi num_factor threshold_dis;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% captured the background model
mus     = model{1};
sigmas  = model{2};
weights = model{3};


% capturing the sift features
convimg_cur = zeros(row_img,column_img,byte_img);
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

ali_bkimg = aligmentImg_zcq(bkimg,H_full);

subimg_full = abs(ali_bkimg - grayImage(img_cur));

siftfeatures_cur = features_cur(:,index_full);

showobjimg = showObjInfo(subimg_full,siftfeatures_cur');

global g_displayMatrixImage
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,2,2,ali_bkimg,grayImage(img_cur),subimg_full,showobjimg)

[labels_img, numlabels] = slicmex(uint8(convimg_cur),num_multi,num_factor);


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


list_all_pre = [];
list_all_cur = [];

list_mea_pre = [];
list_mea_cur = [];

re_fgimg = zeros(row_img,column_img,byte_img);
re_fgimg(:,:,1) = 255;
[row_t column_t] = size(features_pre);
count = 1;
list_H = {};
lineimg = img_cur;
% transform image in different super pixels
for label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);

    [H src tar ok] = getHomography_ransac(tempx_cur,tempx_pre,threshold_dis);

    list_H{count} = H;
    ali_bkimg = aligmentImg_zcq(bkimg,H);

    subimg_multi = abs(ali_bkimg - grayImage(img_cur));

    info_pre = tempf_pre(:,ok);
    info_cur = tempf_cur(:,ok);


    list_all_pre = [list_all_pre; info_pre'];
    list_all_cur = [list_all_cur; info_cur'];

    list_mea_pre = [list_mea_pre; mean(info_pre')];
    list_mea_cur = [list_mea_cur; mean(info_cur')];

    pos_pre = round(mean(info_pre'));
    pos_cur = round(mean(info_cur'));

    lineimg = drawLine(lineimg,pos_pre,pos_cur,3,[100 101 140]);

    showobjimg = showObjInfo(subimg_multi,info_cur');

    subimg = clearTemplateImg(subimg_multi,labels_img,label,[255 0 0]);

    re_fgimg = mergeImg(re_fgimg,subimg);

    displayMatrixImage(1,2,3,lineimg,labels_img*10,re_fgimg,bkimg,subimg_full,showobjimg)

    count = count + 1;
end


%{
t1 = list_mea_pre';
t1(3,:) = 1;

t2 = list_mea_cur';
t2(3,:) = 1;

[tH tsrc ttar tok] = getHomography_ransac(list_mea_pre',list_mea_cur',8);
ok

value = t2(:,tok);

showimg = showObjInfo(img_cur,value');

figure
g_displayMatrixImage = 1
displayMatrixImage(1,1,1,showimg)
%}

% the temp end of program
input('pause')

