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

global segment_matrix;

[row_img column_img byte_img] = size(img);

re_similar = zeros(row_img,column_img);

[row_t column_t] = size(segment_matrix);
count = 0;

for i = 1:row_t
    value = segment_matrix(i,2);

    for  j = 1:value
        segmentnums = segment_matrix(i,1);

        [labels_img numlabels] = segmentImg_SLIC_rand(uint8(img),segmentnums,num_factor,num_scale);

        fillsimilar = fgimg2similar(fgimage,labels_img);

        re_similar = re_similar + fillsimilar;

        count = count + 1;
    end
end

re_similar = re_similar/count;
