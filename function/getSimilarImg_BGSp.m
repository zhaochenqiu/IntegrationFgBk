function [simimg subimg simsubimg] = getSimilarImg_BGSp(img,model,srcimg);

bkimg = model{1};


global g_subRange;

global segment_start segment_num segment_border;


subimg = subImage_range(img,bkimg,g_subRange);
simsubimg = subimg;
subimg = sum(subimg,3);

global g_fgthrcue;
subimg = thresholdImage(subimg,g_fgthrcue*255);

simimg = fgimage2similar_plus(uint8(img),subimg,segment_start,segment_num,segment_border);



