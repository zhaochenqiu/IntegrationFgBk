function re_objs = segments2superpixels(img_lab,img_src,threshold_objcnt)

if nargin == 2
	threshold_objcnt = 64;
end

[row_img column_img byte_img] = size(img_src);
splitimage = zeros(row_img,column_img,byte_img);

splitimage(:,:,1) = img_lab;
splitimage(:,:,2) = img_lab;
splitimage(:,:,3) = img_lab;


objmask		= zeros(row_img,column_img);
objimage	= zeros(row_img,column_img,byte_img);

oldobjmask = objmask;

judgemask = zeros(row_img,column_img);

length = row_img * column_img;

stack1 = zeros(length,2);
stack2 = zeros(length,2);

imginfo = zeros(1,3);
posinfo = zeros(1,5);

tempshowimg = zeros(row_img,column_img,byte_img);

count = 1;


% the temp var
storeimg = zeros(row_img,column_img);

re_objs = {};


time1 = 0;
time2 = 0;
time3 = 0;
time4 = 0;
time5 = 0;

for i = 1:row_img
	for j = 1:column_img
		posr = i;
		posc = j;

		if judgemask(posr,posc) == 0

			%objmask		= abs(objmask - objmask);
			%objimage	= abs(objimage - objimage);
			imginfo		= abs(imginfo - imginfo);
			posinfo		= abs(posinfo - posinfo);

			%objmask(:,:) = 0;
			%objimage(:,:,:) = 0;

			fillFlood(splitimage,objimage,judgemask,objmask,[posr posc],stack1,stack2,imginfo,posinfo);

			obj_left	= posinfo(1) + 1;
			obj_top		= posinfo(2) + 1;
			obj_right	= posinfo(3) + 1;
			obj_bottom	= posinfo(4) + 1;
			obj_count = posinfo(5);
	
			objdata_img		= img_src(obj_top:obj_bottom,obj_left:obj_right,:);
			objdata_mask	= objmask(obj_top:obj_bottom,obj_left:obj_right,:);
		
			tempindex = objdata_mask ~= 255;

			tempimage = objdata_img(:,:,1);
			tempimage(tempindex) = 0;
			objdata_img(:,:,1) = tempimage;

			tempimage = objdata_img(:,:,2);
			tempimage(tempindex) = 0;
			objdata_img(:,:,2) = tempimage;

			tempimage = objdata_img(:,:,3);
			tempimage(tempindex) = 0;
			objdata_img(:,:,3) = tempimage;




			%index = objmask == 255;
			%judgemask(index) = 255;
			%objmask(index) = 0;


			if obj_count > threshold_objcnt
				objinfo = [obj_left obj_top obj_right obj_bottom obj_count];
				objdata = {objdata_img,objdata_mask,objinfo ,imginfo};

				%storeimg(index) = 255;

				re_objs = {re_objs{:} , objdata};

				count = count + 1;
			end

			index = objmask == 255;
			objmask(index) = 0;
			judgemask(index) = 255;
		end
	end

%	showSchedule(i,row_img,'splitimage');
end


%input('pause')


