function re_objs = getSuperPixel_SLIC(img,labelnum,compactness)

if nargin == 1
	labelnum = 200;
	compactness = 10;
end

if nargin == 2
	compactness = 10;
end

[row_img column_img byte_img] = size(img);

[labels, numlabels] = slicmex(img,labelnum,compactness);

re_objs = segments2superpixels(labels,img,1);

