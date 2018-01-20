function result = grayImage(image)

% Author:Q
% Date:2013/12/13
% Describe:ת�Ҷ�ͼ����
% ģ��matlabд����Ч�ʼ�����matlab�Դ�������������

% ����˵��:
%    �������:
%        image  ����ͼ��,��ɫͼ��
%
%    �������:
%        result ����Ҷ�ͼ��λ�����Ϊ1

[row column num] = size(image);

template = [0.299 ; 0.587 ; 0.114]; %��������ѧ��ʽ

image       = reshape(image(:),row * column,num);     % ת���������ݽ�������
result      = imlincomb(template(1),image(:,1),template(2),image(:,2),template(3),image(:,3));
result      = reshape(result,[row column]);  % ת�����������