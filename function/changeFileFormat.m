function re_filename = changeFileFormat(filename,format)

[row_file column_file] = size(filename);
[row_for column_for] = size(format);

offset = column_file - column_for;

re_filename = filename;

for i = 1:column_for
	pos = offset + i;
	re_filename(pos) = format(i);
end
