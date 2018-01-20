function re_image = colorSegments(img_lab,img_src)

[row_img column_img byte_img] = size(img_src);

maxlabel = max(max(img_lab));
colors = rand(maxlabel,3)*255;

re_image = zeros(row_img,column_img,byte_img);
showimage = img_src;

for i = 1:maxlabel
	label = i;

	color = colors(i,:);

	index = img_lab == label;

	rimage = img_src(:,:,1)*0.5 + color(1)*0.5;
	gimage = img_src(:,:,2)*0.5 + color(2)*0.5;
	bimage = img_src(:,:,3)*0.5 + color(3)*0.5;

	index = ~index;

	rimage(index) = 0;
	gimage(index) = 0;
	bimage(index) = 0;

	showimage(:,:,1) = rimage;
	showimage(:,:,2) = gimage;
	showimage(:,:,3) = bimage;
	
	re_image = re_image + showimage;
end
