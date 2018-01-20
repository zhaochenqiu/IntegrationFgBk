function re_img = segments2labels(img_lab,threshold_objcnt)

if nargin < 2
    threshold_objcnt = 128;
end

[row_img column_img byte_img] = size(img_lab);

byte_img = 3;

splitimage = zeros(row_img,column_img,byte_img);

splitimage(:,:,1) = img_lab;
splitimage(:,:,2) = img_lab;
splitimage(:,:,3) = img_lab;

re_img = zeros(row_img,column_img) - 1 ;
objmask		= zeros(row_img,column_img);
objimage	= zeros(row_img,column_img,byte_img);

judgemask = zeros(row_img,column_img);

length = row_img * column_img;

stack1 = zeros(length,2);
stack2 = zeros(length,2);

imginfo = zeros(1,3);
posinfo = zeros(1,5);

count = 1;

global g_displayMatrixImage
g_displayMatrixImage = 1;
figure
for i = 1:row_img
	for j = 1:column_img
		posr = i;
		posc = j;

		if judgemask(posr,posc) == 0
			imginfo		= abs(imginfo - imginfo);
			posinfo		= abs(posinfo - posinfo);

			fillFlood(splitimage,objimage,judgemask,objmask,[posr posc],stack1,stack2,imginfo,posinfo);

			obj_left	= posinfo(1) + 1;
			obj_top		= posinfo(2) + 1;
			obj_right	= posinfo(3) + 1;
			obj_bottom	= posinfo(4) + 1;
			obj_count = posinfo(5);

			index = objmask == 255;
			objmask(index) = 0;
			judgemask(index) = 255;

            if obj_count > threshold_objcnt
                re_img(index) = count;
                count = count + 1;
            end

%            displayMatrixImage(1,1,3,splitimage*20,objimage,judgemask)
		end
	end
end
