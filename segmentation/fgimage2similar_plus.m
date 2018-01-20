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


[row_img column_img byte_img] = size(img);


re_similar = zeros(row_img,column_img);

threshold = startnum;

for i = 1:num
	similar = subImg2Similar_2(img,fgimage,fgimage,round(threshold));


	fillsimilar = fillSimilarImage(similar);

	re_similar = re_similar + fillsimilar*(1/num);

	threshold = threshold + border;
end
