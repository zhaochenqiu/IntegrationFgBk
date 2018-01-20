function [re_map re_map_fg] = getMapRange_multi_model2img(grayimg_cur,modelimg,label_list,H_list,label_img,range,H_error)

if nargin == 5
    range = 2;
end

[row_img column_img byte_img] = size(grayimg_cur);

re_map = zeros(row_img,column_img,2) - 1;
re_map_fg = zeros(row_img,column_img,2) - 1;

template    = createCenterTemplate(range);
index       = template2index(template);




for i = 1:row_img
    for j = 1:column_img
        value = modelimg(i,j,:);

        label = label_img(i,j) + 1;


        %if label > maxnum | label < minnum
        %    label
        %    input('pause the label')
        %    continue
        %end

       
        try
            H = H_list{label};
        catch
            H = H_error;
            % disp('there is a error in getMapRange_multi_model2img, use the H_error');
            %{
            label
            size(H_list)
            H_list
            input('pause')
            %}
        end

        pos = [j i 1]';
        pos_ = H*pos;

        posx = pos_(1,1)/pos_(3,1);
        posy = pos_(2,1)/pos_(3,1);

        posx = round(posx);
        posy = round(posy);

        if posx > 0 & posx < column_img + 1 & posy > 0 & posy < row_img + 1
            left    = posx - range;
            top     = posy - range;
            right   = posx + range;
            bottom  = posy + range;

            left    = max([1 left]);
            top     = max([1 top]);
            right   = min([right column_img]);
            bottom  = min([bottom row_img]);

            matrix = grayimg_cur(top:bottom,left:right,:);
            matrix = abs(matrix - value);

            minvalue = min(min(matrix));

            [r c] = find(matrix == minvalue);


            [row_t column_t] = size(r);

            if row_t + column_t > 2
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 方法一，找出最靠近的那个，缺点是运行时间太长
            % 测试得到，确实是因为相同像素值的点
            % [r c] = getCloseCenter(r,c,range);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 方法二,取中间位置的那个
                pos = round(row_t/2);
                r = r(pos);
                c = c(pos);
           end



            % check the center position

            %{
            list = r + c;
            list = abs(list - range);
            pos = find(list == min(min(list)));
            pos = pos(1);

            r = r(pos);
            c = c(pos);
            %}

            mapx = left + c - 1;
            mapy = top + r - 1;

            re_map(i,j,1) = mapx;
            re_map(i,j,2) = mapy;

            re_map_fg(i,j,1) = posx;
            re_map_fg(i,j,2) = posy;
        end
    end
end

%{
subimg = abs(grayimg_cur - modelimg);

global g_displayMatrixImage
g_displayMatrixImage = 1;
figure
displayMatrixImage(1,1,3,grayimg_cur,modelimg,subimg)

input('pause')
%}
