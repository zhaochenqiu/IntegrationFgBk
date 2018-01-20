function [re_img re_img_ref]  = aligmentImg(img,img_ref,H);

[row_img column_img byte_img] = size(img);

box_ref = [1  size(img_ref,2) size(img_ref,2)  1 ;
        1  1           size(img_ref,1)  size(img_ref,1) ;
        1  1           1            1 ] ;
box_ref_ = inv(H) * box_ref ;
box_ref_(1,:) = box_ref_(1,:) ./ box_ref_(3,:) ;
box_ref_(2,:) = box_ref_(2,:) ./ box_ref_(3,:) ;


ur = min([1 box_ref_(1,:)]):max([size(img,2) box_ref_(1,:)]) ;
vr = min([1 box_ref_(2,:)]):max([size(img,1) box_ref_(2,:)]) ;

[u,v] = meshgrid(ur,vr) ;

%u = round(u);
%v = round(v);

img_ = vl_imwbackward(img,u,v );

z_ = H(3,1) * u + H(3,2) * v + H(3,3) ;
u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;

%u_ = round(u_);
%v_ = round(v_);

img_ref_ = vl_imwbackward(img_ref,u_,v_ );

img_(isnan(img_))			= -1;
img_ref_(isnan(img_ref_))	= -1;

re_img		= img_;
re_img_ref	= img_ref_;

[row_rimg column_rimg byte_rimg] = size(re_img);

[left top right bottom] = getImgPos(re_img);

adjimg = re_img(top:bottom,left:right,:);
adjimg_ref = re_img_ref(top:bottom,left:right,:);

%{
tempimg = zeros(row_img,column_img,byte_img);
tempimg_ref = zeros(row_img,column_img,byte_img);

min_row     = top - 1;
min_column  = left - 1;

left    = left      - min_column;
right   = right     - min_column;
top     = top       - min_row;
bottom  = bottom    - min_row;
%}
re_img      = resizeImg(adjimg,row_img,column_img);
re_img_ref  = resizeImg(adjimg_ref,row_img,column_img);

%{

tempimg(top:bottom,left:right,:) = adjimg;
tempimg_ref(top:bottom,left:right,:) = adjimg_ref;

re_img		= tempimg;
re_img_ref	= tempimg_ref;
%}
