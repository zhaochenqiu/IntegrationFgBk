function data = loadData(path,extention)

% 参数解释:
%    输入参数:
%        path       图像路径
%        extention  图像格式
%
%    输出参数:
%        data       读出的图像数据矩阵，数据格式为 imgsize * imgdeep * framenum 
%                   图像数据长度（一维） * 图像深度（rgb） * 图像帧数
%
%    全局参数:
%        g_height   图像的高
%        g_width    图像的宽
%        g_imgdeep  图像的深度

global g_height g_width g_imgdeep

if(path(end) ~= '/')
    path = [path '/'];
end

fprintf(1, 'Loading files from %s...\n', path);

files = dir([path '*.' extention]);
files = sort({files.name});

% Number of frames
% 文件的数量,详细参考files的文件格式
frames = size(files, 2);

% Get the dimension of one picture
% 取出第一张图片以方便申请内存
sizes = size(imread([path files{1}]));

% If we only have greyscale
if(length(sizes) == 2)
    sizes(3) = 1; % Pretend we have a third dimension
end 

data = zeros([sizes, frames], 'uint8');

for tt = 1:frames
    fprintf(1, 'Reading file %d: %s\r', tt, files{tt});
    im = imread([path files{tt}]);
    data(:, :, :, tt) = im;
end

