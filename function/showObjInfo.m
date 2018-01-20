function showimg = showObjInfo(fgimage,objinfo,threshold_rate)

[row_info column_info]			= size(objinfo);
[row_img column_img byte_img]	= size(fgimage);

showimg = zeros(row_img,column_img,3);

if nargin == 2
    threshold_rate = 0.2;
end


if byte_img == 3
	showimg = showimg + fgimage;
else
	for i = 1:3
		showimg(:,:,i) = showimg(:,:,i) + fgimage;
	end
end


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

	tempimg = fgimage(top:bottom,left:right,1);
	index = tempimg == 255;
	fgnum = sum(sum(index));
	allnum = (bottom - top + 1)*(right - left + 1);
	fgrate = fgnum/allnum;


	if fgrate > threshold_rate
		showimg(top:bottom,left:right,1) = 255;
		showimg(top:bottom,left:right,2) = 0;
		showimg(top:bottom,left:right,3) = 0;
	else
		showimg(top:bottom,left:right,1) = 101;
		showimg(top:bottom,left:right,2) = 100;
		showimg(top:bottom,left:right,3) = 140;

	end
end
