function [] = detection(data);

% ����˵��:
%    �������:
%        data ͼ���������ݣ�ͼ�����ݱ�����һά

% imgsizeΪͼ�����ݳ���
% imgdeepΪͼ�����
% framenumΪͼ�������������������ж���֡ͼ��

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
