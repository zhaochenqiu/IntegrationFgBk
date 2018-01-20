function re_data = normalRowData(data)

[row_t column_t] = size(data);

for i = 1:column_t
    tempdata = data(:,i);
    value = max(tempdata);
    tempdata = tempdata/value;
    data(:,i) = tempdata;
end

re_data = data;
