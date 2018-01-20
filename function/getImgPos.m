function [re_left re_top re_right re_bottom] = getImgPos(img)

[row_img column_img byte_img] = size(img);

judgeimg = img(:,:,1);

top		= 1;
left	= 1;
bottom	= row_img;
right	= column_img;

judge	= 1;
while judge == 1
	value = sum(judgeimg(top,:));

	if value > 0
		judge = 0;
	else
		top = top + 1;
	end
end


judge	= 1;
while judge == 1
	value = sum(judgeimg(bottom,:));

	if value > 0
		judge = 0;
	else
		bottom = bottom - 1;
	end
end


judge	= 1;
while judge == 1
	value = sum(judgeimg(:,left));

	if value > 0
		judge = 0;
	else
		left = left + 1;
	end
end

judge	= 1;
while judge == 1
	value = sum(judgeimg(:,right));

	if value > 0
		judge = 0;
	else
		right = right - 1;
	end
end

re_left		= left;
re_top		= top;
re_right	= right;
re_bottom	= bottom;
