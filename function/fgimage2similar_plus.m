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
global template num_multi num_factor threshold_dis threshold_disbk;



[row_img column_img byte_img] = size(img);


re_similar = zeros(row_img,column_img);

threshold = startnum;

for i = 1:num
    [labels_img, numlabels] = slicmex(uint8(img),threshold,num_factor);

    fillsimilar = fgimg2similar(fgimage,labels_img);

	re_similar = re_similar + fillsimilar;

	threshold = threshold + border;
end

re_similar = re_similar/num;
