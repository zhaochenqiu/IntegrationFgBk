function re_bkcues = getBkCues(convimg_cur,X_pre,X_cur,features_cur,matches)

% define the parameter
[row_img column_img byte_img] = size(convimg_cur);

global g_spBkCuesNum g_spBkCuesFactor;


labels_img = zeros(row_img,column_img);
numlabels = 0;

if g_spBkCuesNum ~= 1
    [labels_img, numlabels] = slicmex(uint8(convimg_cur),g_spBkCuesNum,g_spBkCuesFactor);
end



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
parfor label = minnum:maxnum
    index = label_list == label;

    tempx_pre = X_pre(:,index);
    tempx_cur = X_cur(:,index);

%    tempf_pre = features_pre(:,index);
    tempf_cur = features_cur(:,index);


    [H src tar ok] = getHomography_ransac(tempx_pre,tempx_cur,g_disRscBkCues);

    objinfo = tempf_cur(:,ok);


    if sum(ok) < 4
    else
        store_objinfo = [store_objinfo objinfo];
    end
end


re_bkcues = store_objinfo';

