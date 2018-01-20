function [r c] = getCloseCenter(r_list,c_list,range)

if ~exist('template_getCloseCenter')
    global template_getCloseCenter
    template_getCloseCenter = createCenterTemplate(range);
end

[row column] = size(r_list);

len = row;
if column > len
    len = column;
end

store_r = 0;
store_c = 1;
store_value = 0;

for i = 1:len
    posr = r_list(i);
    posc = c_list(i);

    if template_getCloseCenter(posr,posc) > store_value
        store_r = posr;
        store_c = posc;
        store_value = template_getCloseCenter(posr,posc);
    end
end

r = store_r;
c = store_c;
