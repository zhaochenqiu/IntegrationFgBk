function re_similar = fgimage2similar_plus(img,fgimage,startnum,num,border)

if nargin == 2
	%{
	startnum = 8;
	num = 12;
	border = 16;
	%}

	startnum = 64;
	num = 2;
	border = 64;
end
global template num_multi num_factor num_scale threshold_dis threshold_disbk;

global segment_times;


[row_img column_img byte_img] = size(img);


re_similar = zeros(row_img,column_img);

threshold = startnum;


for i = 1:num
    for j = 1:segment_times
%       [labels_img, numlabels] = slicmex(uint8(img),threshold,num_factor);
        [labels_img numlabels] = segmentImg_SLIC_rand(uint8(img),threshold,num_factor,num_scale);

        fillsimilar = fgimg2similar(fgimage,labels_img);

        re_similar = re_similar + fillsimilar;
    end

    threshold = threshold + border;
end

re_similar = re_similar/(num*segment_times);
