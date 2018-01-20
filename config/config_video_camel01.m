global path_img format_img path_save;

if systemJudge() == 1
    path_img    = '~/dataset/FBMS_Testset/Testset/camel01';
    path_save   = '~/dataset/homography_multi/FBMS_Testset/camel01';
    format_img  = 'jpg';
else
    if exist('E:') == 0
        path_img    = 'D:\dataset\FBMS_Testset\Testset\camel01';
        path_save   = 'D:\dataset\homography_multi\FBMS_Testset\camel01';
        format_img  = 'jpg';
    else
        path_img    = 'E:\dataset\FBMS_Testset\Testset\camel01';
        path_save   = 'E:\dataset\homography_multi\FBMS_Testset\camel01';
        format_img  = 'jpg';
    end
end

