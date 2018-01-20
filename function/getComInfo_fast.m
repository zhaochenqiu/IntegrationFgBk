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

% detector = cv.SURF('HessianThreshold',20, 'Extended', true,'NOctaves',8,'NOctaveLayers',6);

%detector = cv.SURF('HessianThreshold',10, 'Extended', true,'NOctaves',8,'NOctaveLayers',6);
 detector = cv.SIFT('EdgeThreshold',20,'ConstrastThreshold',0.001);
% detector = cv.SURF('HessianThreshold',10, 'Extended', true,'NOctaves',8,'NOctaveLayers',6);
% detector = cv.KAZE('Threshold',0.0001);


% detector = cv.AKAZE('Threshold',0.0001);

% detector = cv.ORB('MaxFeatures',50000, 'EdgeThreshold',0.001);

% detector = cv.ORB('MaxFeatures',5000,'EdgeThreshold',31,'PatchSize',61);



% detector = cv.BRISK('Threshold',10);
%  detector = cv.BRISK();

% detector = cv.AKAZE('Upright',0.0005);

% input('pause')



[f_pre d_pre] = detector.detectAndCompute(uimg_pre);
[f_cur d_cur] = detector.detectAndCompute(uimg_cur);

% [key_obj feat_obj] = detector.detectAndCompute(im_obj);
% [key_sce feat_sce] = detector.detectAndCompute(im_sce);


if ~isempty(strfind(detector.defaultNorm(), 'Hamming'))
    opts = {'LSH', 'TableNumber',12, 'KeySize',24, 'MultiProbeLevel',2};
else
    opts = {'KDTree', 'Trees',10};
end


matcher = cv.DescriptorMatcher('FlannBasedMatcher', 'Index',opts);

matches = matcher.match(d_pre,d_cur);
%

%global g_t g_t2;
%g_t = matches;
%g_t2 = d_pre;
%
%
%input('pause')
%


dists = [matches.distance];
cutoff = 6*min(dists);
% cutoff_bk = 6*min(dists);
% matches_bk = matches(dists <= cutoff_bk);
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



% captured the homography between bkimg and img_cur
[H_full src tar index_full] = getHomography_ransac(X_cur,X_pre,g_disRscFgCues);

re_H = H_full;
re_index_full = [];




% X_pre = cat(1, f_pre([matches_bk.queryIdx] + 1).pt);
% X_cur = cat(1, f_cur([matches_bk.trainIdx] + 1).pt);
% 
% X_pre = X_pre';
% X_cur = X_cur';
% 
% X_pre(3,:) = 1;
% X_cur(3,:) = 1;
% 
% features_pre = X_pre;
% features_cur = X_cur;
% 
% global g_rateScale;
% features_pre(3,:) = g_rateScale;
% features_cur(3,:) = g_rateScale;


% features_cur是四维的，x,y,scale and angel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
re_convimg_cur = convimg_cur;                       %
re_grayimg_cur = grayimg_cur;                       %
re_X_pre = X_pre;                                   %
re_X_cur = X_cur;                                   %
re_features_cur = features_cur;                     %
% re_matches = matches_bk;                               %
re_matches = matches;                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


