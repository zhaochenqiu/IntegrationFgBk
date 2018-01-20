function re_fgimg = segmentByFBCues(fgimg_cues,bkimg_cues)

[row_img column_img byte_img] = size(fgimg_cues);

re_fgimg = zeros(row_img,column_img,byte_img);
