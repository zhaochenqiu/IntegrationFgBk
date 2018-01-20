function [re_convimg_cur re_grayimg_cur re_H re_X_pre re_X_cur re_features_cur re_matches re_index_full] = getComInfo(img_cur,bkimg)

global g_template num_multi num_factor g_disRscFgCues;

[row_img column_img byte_img] = size(img_cur);

convimg_cur = imfilter(img_cur,g_template,'replicate');

grayimg_pre = bkimg;
grayimg_cur = grayImage(convimg_cur);

uimg_pre = uint8(grayimg_pre);
uimg_cur = uint8(grayimg_cur);



% -------------------------------------------------------------
% get the common information by mexopencv
% detector = cv.ORB();
% detector.MaxFeatures = 50000;

% detector = cv.SURF('HessianThreshold',0);
detector = cv.SIFT();

% detector = cv.BRISK();
% detector = cv.AKAZE();
% detector = cv.KAZE();



[f_pre d_pre] = detector.detectAndCompute(uimg_pre);
[f_cur d_cur] = detector.detectAndCompute(uimg_cur);

% [key_obj feat_obj] = detector.detectAndCompute(im_obj);
% [key_sce feat_sce] = detector.detectAndCompute(im_sce);


if ~isempty(strfind(detector.defaultNorm(), 'Hamming'))
    opts = {'LSH', 'TableNumber',6, 'KeySize',12, 'MultiProbeLevel',1};
else
    opts = {'KDTree', 'Trees',5};
end


matcher = cv.DescriptorMatcher('FlannBasedMatcher', 'Index',opts);

matches = matcher.match(d_pre,d_cur);
%
dists = [matches.distance];
cutoff = 6*min(dists);
matches = matches(dists <= cutoff);

X_pre = cat(1, f_pre([matches.queryIdx] + 1).pt);
X_cur = cat(1, f_cur([matches.trainIdx] + 1).pt);

X_pre = X_pre';
X_cur = X_cur';

X_pre(3,:) = 1;
X_cur(3,:) = 1;

features_pre = X_pre;
features_cur = X_cur;

global g_rateScale;
features_pre(3,:) = g_rateScale;
features_cur(3,:) = g_rateScale;



% features_cur是四维的，x,y,scale and angel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
re_convimg_cur = convimg_cur;                       %
re_grayimg_cur = grayimg_cur;                       %
re_X_pre = X_pre;                                   %
re_X_cur = X_cur;                                   %
re_features_cur = features_cur;                     %
re_matches = matches;                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% captured the homography between bkimg and img_cur
[H_full src tar index_full] = getHomography_ransac(X_cur,X_pre,g_disRscFgCues);

re_H = H_full;
re_index_full = [];

