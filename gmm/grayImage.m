function result = grayImage(image)

% Author:Q
% Date:2013/12/13
% Describe:转灰度图函数
% 模仿matlab写法，效率几乎和matlab自带函数不相上下

% 参数说明:
%    输入参数:
%        image  输入图像,彩色图像
%
%    输出参数:
%        result 输出灰度图像，位数深度为1

[row column num] = size(image);

template = [0.299 ; 0.587 ; 0.114]; %著名心里学公式

image       = reshape(image(:),row * column,num);     % 转成线性数据进行运算
result      = imlincomb(template(1),image(:,1),template(2),image(:,2),template(3),image(:,3));
result      = reshape(result,[row column]);  % 转回来进行输出