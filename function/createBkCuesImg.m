function re_img = createBkCuesImg(img,objinfo,bkvalue)

[row_img column_img byte_img] = size(img);
[row_info column_info]		  = size(objinfo);

re_img = zeros(row_img,column_img);


for i = 1:row_info
	label	= i;
	data	= objinfo(label,:);

	x = data(1);
	y = data(2);
	scale = data(3);

	x = round(x);
	y = round(y);
	border = round(scale);


	left	= x - border;
	right	= x + border;
	top		= y - border;
	bottom	= y + border;

	if left < 1
		left = 1;
	end

	if top < 1
		top = 1;
	end

	if right > column_img
		right = column_img;
	end

	if bottom > row_img
		bottom = row_img;
	end

    re_img(top:bottom,left:right) = re_img(top:bottom,left:right) + bkvalue;
end
