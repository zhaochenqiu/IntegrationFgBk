function re_fgimg = getFgCues(img_cur,model)

% load the algorithms parameter
global template num_multi num_factor threshold_dis;

% define the parameter
[row_img column_img byte_img] = size(img_cur);

% capturing the sift features
% convimg_pre = zeros(row_img,column_img,byte_img);
convimg_cur = zeros(row_img,column_img,byte_img);

convolution_c(convimg_pre,img_pre,template);
convolution_c(convimg_cur,img_cur,template);

grayimg_pre = grayImage(convimg_pre);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this part is going to remove
num = size(matches,2);

for t = 1:400
    % estimate homograhy
    subset = vl_colsubset(1:num,4);

    A = [];

    for i = subset
        A = cat(1, A, kron(X_pre(:,i)', vl_hat(X_cur(:,i)))) ;
    end

    [U,S,V] = svd(A) ;
    H{t} = reshape(V(:,9),3,3) ;

    % score homography
    X_cur_ = H{t} * X_pre;
    du = X_cur_(1,:)./X_cur_(3,:) - X_cur(1,:)./X_cur(3,:);
    dv = X_cur_(2,:)./X_cur_(3,:) - X_cur(2,:)./X_cur(3,:);
    ok{t} = (du.*du + dv.*dv) <  threshold_dis;

    score(t) = sum(ok{t}) ;
end

[score, best] = max(score);
H = H{best};
ok = ok{best};

H_full = H;

[tempali_pre tempali_cur] = aligmentImg(convimg_pre,convimg_cur,H);

tempsubimg = subImage_range(convimg_pre,tempali_cur);

tempsift = X_cur(:,ok);

tempf = f_pre(:,matches(1,:));
tempf = tempf(:,ok);

tempshowobjimg = showObjInfo(convimg_cur,tempf');
%[aliimg_pre aliimg_cur] = aligmentImg(convimg_pre,convimg_cur,H);

%subimg = subImage_range(convimg_pre,aliimg_cur);

clear score;
clear H;
clear ok;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% get the superpixel of image
% [labels_img, numlabels] = slicomex(uint8(convimg_cur),num_multi);
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


% the temp code for test algorithms
global g_displayMatrixImage 
g_displayMatrixImage = 1;
figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the code in this part is going to remove
showsiftimg = convimg_cur;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% the initialize of foreground cues
re_fgimg = zeros(row_img,column_img,byte_img);
re_fgimg(:,:,1) = 255;

% transform image in different super pixel
for label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);

    num = size(tempx_cur,2);

    for t = 1:(min([400 10*num]))
        % estimate homograhy
        subset = vl_colsubset(1:num,4);

        A = [];

        for i = subset
            A = cat(1, A, kron(tempx_pre(:,i)', vl_hat(tempx_cur(:,i)))) ;
        end

        [U,S,V] = svd(A) ;
        H{t} = reshape(V(:,9),3,3) ;

        % score homography
        tempx_cur_ = H{t} * tempx_pre;
        du = tempx_cur_(1,:)./tempx_cur_(3,:) - tempx_cur(1,:)./tempx_cur(3,:);
        dv = tempx_cur_(2,:)./tempx_cur_(3,:) - tempx_cur(2,:)./tempx_cur(3,:);
        ok{t} = (du.*du + dv.*dv) <  threshold_dis;

        score(t) = sum(ok{t}) ;
    end

    if num == 0
        H = H_full;
        ok = [];
    else
        [score, best] = max(score);
        H = H{best};
        ok = ok{best};
    end


    % to sure if the result is right
    tempsift = tempf_cur(:,ok);
    showsiftimg = showObjInfo(showsiftimg,tempsift');


    [row_t column_t] = size(tempsift)
    if (column_t < 8)
        H = H_full;
    end


    [aliimg_pre aliimg_cur] = aligmentImg(convimg_pre,convimg_cur,H);

    subimg = subImage_range(convimg_pre,aliimg_cur);

    subimg = clearTemplateImg(subimg,labels_img,label,[255 0 0]);

    re_fgimg = mergeImg(re_fgimg,subimg);

    displayMatrixImage(1,2,3,subimg,showsiftimg,tempshowobjimg,re_fgimg,abs(img_cur - img_pre),tempsubimg);

%    size(tempsift)

    clear score;
    clear H;
    clear ok;
end

input('end of the getFgCues')

% re_fgimg = abs(convimg_pre - convimg_cur);
