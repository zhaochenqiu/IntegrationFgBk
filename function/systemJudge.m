function re_judge = systemJudge()

% unix: judge = 1
% win: judge = 0;

str = computer;

str_unix = 'GLNXA64';

[row1 column1] = size(str);
[row2 column2] = size(str_unix);

re_judge = 0;

if row1 == row2 & column1 == column2
    if sum(str == str_unix) == 7
        re_judge = 1;
    end
end
