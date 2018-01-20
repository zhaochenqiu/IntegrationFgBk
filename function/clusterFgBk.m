function re_similar = clusterFgBk(img,fgimage,startnum,num,border,fgcues,bkcues)

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

fgmask = fgcues;

showimg = showObjInfo(fgcues,bkcues);
showimg = sum(showimg,3);
index = showimg == 341;
index = ~index;
bkmask = showimg;
bkmask(index) = 0;
index = ~index;
bkmask(index) = 255;


for i = 1:row_t
    value = segment_matrix(i,2);

    for  j = 1:value
        segmentnums = segment_matrix(i,1);

        [fglabels_img fgnumlabels] = segmentImg_SLIC_rand_msk(uint8(img),segmentnums,fgmask,num_factor,num_scale);

        [bklabels_img bknumlabels] = segmentImg_SLIC_rand_msk(uint8(img),segmentnums,bkmask,num_factor,num_scale);


        fgfillsimilar = fgimg2similar(fgimage,fglabels_img);
        bkfillsimilar = fgimg2similar(fgimage,bklabels_img);

        fillsimilar = (fgfillsimilar + bkfillsimilar)/2;
%        fillsimilar = fgfillsimilar;

        re_similar = re_similar + fillsimilar;

        count = count + 1;
    end
end

re_similar = re_similar/count;
