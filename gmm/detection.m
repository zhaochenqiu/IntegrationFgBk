function [] = detection(data);

% 参数说明:
%    输入参数:
%        data 图像序列数据，图像数据必须是一维

% imgsize为图像数据长度
% imgdeep为图像深度
% framenum为图像序列数量，及到底有多少帧图像

[imgsize imgdeep framenum] = size(data);

[row column byte] = size(data(:,:,:,1));
tempgray = grayImage(data(:,:,:,1));

mus = zeros(row,column,byte);
mus(:,:,1) = tempgray(:,:,1);

sigmas = zeros(row,column,byte);
sigmas = sigmas + 2;

weight = zeros(row,column,byte);
weight(:,:,1) = 1;

threshold = 0.3;


for i = 1:framenum
    fprintf(1,'Evaluating frame %d.... \n',i);
    
    image = double(data(:,:,:,i));
    grayimage = grayImage(image);

    [compare fgimage similary] = getFgImage(grayimage,mus,sigmas,weight,threshold);
    
    [mus sigmas weight] = updateBkImage(grayimage,mus,sigmas,weight,compare);
    
    bestbkimage = getBestBkImage(mus,weight);
    
    showsubimage = morphology(fgimage,5);
    
    displayResult(i,image,bestbkimage,fgimage,showsubimage,mus(:,:,1),mus(:,:,2),mus(:,:,3),(1 - similary)*255);
end 
