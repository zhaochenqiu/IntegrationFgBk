function [re_img re_set] = inteFgBkCues(convimg_cur,cuesimg)
% most time are consumed by the slicmex function. test1 is the time of slicmex, tset2 is the entry_inteFgBkCues
%tset1 =
%
%    0.1833
%    0.1834
%    0.1800
%    0.1697
%    0.2751
%    0.2053
%    0.2102
%    0.2078
%
%
%tset2 =
%
%    0.0051
%    0.0040
%    0.0033
%    0.0036
%    0.0041
%    0.0042
%    0.0037
%    0.0042

global g_superMatrix g_superFactor g_template;

[row_img column_img byte_img] = size(cuesimg);
[row_mat column_mat] = size(g_superMatrix);

% define the parameter
[row_img column_img byte_img] = size(convimg_cur);

% capturing the sift features


interimg_set = zeros(row_img,column_img,row_mat);

fgcues = cuesimg(:,:,1);
bkcues = cuesimg(:,:,2);

% this place is expedited by multi-cpu
% for 

% [~,imageToSegment] = Image2ColourSpace(convimg_cur, 'Hsv');



parfor i = 1:row_mat
    num_sp = g_superMatrix(i);

    [labels_img, numlabels] = slicmex(uint8(convimg_cur),g_superMatrix(i),g_superFactor);
    
%    [labels_img, ~] = mexFelzenSegmentIndex(imageToSegment, 1 , g_superMatrix(1), g_superMatrix(2));
%    numlabels = max(max(labels_img));


%     [labels_img numlabels] = segmentImg_SLIC_rand(uint8(convimg_cur),g_superMatrix(i),g_superFactor);

    labels_img = double(labels_img);

    simimg      = zeros(row_img,column_img);
    valuelist   = zeros(numlabels,1);
    numlist     = zeros(numlabels,1);


    entry_inteFgBkCues(double([row_img column_img numlabels]), labels_img, fgcues, bkcues, simimg, valuelist, numlist);

%{
    tempimg     = zeros(row_img,column_img);
    for j = 0:numlabels - 1
        index = labels_img == j;

        value = mean(mean(fgcues(index))) + mean(mean(bkcues(index)));

        tempimg(index) = value;
    end
    %}

    interimg_set(:,:,i) = simimg;
end

re_img = mean(interimg_set,3);
re_set = interimg_set;
