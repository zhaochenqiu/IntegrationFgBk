function re_labels = segmentation_kmeans(image,threshold)

if nargin == 1
	threshold = 200;
end


[row_img column_img byte_img] = size(image);

len_img = row_img*column_img;

image_list = reshape(image,len_img,byte_img);


num = 0;
labels = zeros(len_img,1);

matrixlab = segmentation_recursion(image_list,labels,num,threshold);

matrixlab = reshape(matrixlab,row_img,column_img);


re_labels = zeros(row_img,column_img);

maxlabel = max(max(matrixlab));
count = 1;
for i = 1:maxlabel
	label = i;
	index = matrixlab == label;

	judgevalue = sum(sum(index));

	if judgevalue ~= 0
		re_labels(index) = count;
		count = count + 1;
	end
end

