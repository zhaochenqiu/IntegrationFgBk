function [re_img re_img_ref] = adjImage_msd_safe(img,img_ref,H)


box_ref = [1  size(img_ref,2) size(img_ref,2)  1 ;
        1  1           size(img_ref,1)  size(img_ref,1) ;
        1  1           1            1 ] ;
box_ref_ = inv(H) * box_ref ;
box_ref_(1,:) = box_ref_(1,:) ./ box_ref_(3,:) ;
box_ref_(2,:) = box_ref_(2,:) ./ box_ref_(3,:) ;


ur = round(min([1 box_ref_(1,:)])):round(max([size(img,2) box_ref_(1,:)])) ;
vr = round(min([1 box_ref_(2,:)])):round(max([size(img,1) box_ref_(2,:)])) ;

[row_ur column_ur] = size(ur);
[row_vr column_vr] = size(vr);


MAXLEN = 2000;

if row_ur > MAXLEN | row_vr > MAXLEN | column_ur > MAXLEN | column_vr >	MAXLEN
	re_img = img;
	re_img_ref = img_ref;
else


	[u,v] = meshgrid(ur,vr) ;

	u = round(u);
	v = round(v);

	img_ = vl_imwbackward(img,u,v );

	z_ = H(3,1) * u + H(3,2) * v + H(3,3) ;
	u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
	v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;

	u_ = round(u_);
	v_ = round(v_);

	img_ref_ = vl_imwbackward(img_ref,u_,v_ );

	img_(isnan(img_))			= -1;
	img_ref_(isnan(img_ref_))	= -1;

	re_img		= img_;
	re_img_ref	= img_ref_;

	re_srcimg = img_;
	re_srcimg_ref = img_ref_;


	[left top right bottom] = getImgPos(re_img);

	adjimg = re_img(top:bottom,left:right,:);
	adjimg_ref = re_img_ref(top:bottom,left:right,:);

	re_img		= adjimg;
	re_img_ref	= adjimg_ref;
end


