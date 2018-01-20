[a,b,c] = fileparts(mfilename('fullpath')) ;
[a,b,c] = fileparts(a);
root = a ;

addpath(fullfile(root,'function'));
addpath(fullfile(root,'gmm'));
addpath(fullfile(root,'segmentation'));
addpath(fullfile(root,'segmentation_test'));
addpath(fullfile(root,'FelzenSegment'));


if systemJudge() == 1
%    addpath('~/projects/imageprocessing/common');
%    addpath('~/projects/imageprocessing/common_c');

    addpath('/data/projects/matrix/common_c');
    addpath('/data/projects/matrix/common');
    addpath('/data/projects/matrix/parallel_computing/function/');
    addpath('~/libs/SLIC_mex');
    run('~/libs/vlfeat-0.9.20/toolbox/vl_setup');

    addpath('~/libs/mexopencv/');
    addpath('~/libs/mexopencv/opencv_contrib/');
    addpath('~/libs/mexopencv/test/');
else

    if exist('E:') == 0
        addpath('D:\projects\matrix\imageprocessing\common');
        addpath('D:\projects\matrix\imageprocessing\common_c');
        addpath('D:\tools\SLIC_mex');
        run('D:\tools\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup');
    else
        addpath('E:\projects\matrix\imageprocessing\common');
        addpath('E:\projects\matrix\imageprocessing\common_c');
        addpath('E:\tools\SLIC_mex');
        run('E:\tools\vlfeat-0.9.18-bin\vlfeat-0.9.18\toolbox\vl_setup');
    end
end

