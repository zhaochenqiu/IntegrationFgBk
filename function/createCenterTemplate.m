function template = createCenterTemplate(range)

template = zeros(2*range + 1,2*range + 1);

[row column] = size(template);

pos_r = 1;
pos_c = 0;

move = [0 1];
count = 1;
judge = 1;

while judge ~= 0

    % if can move 
    ifcanmove = 0;

    tempr = pos_r + move(1);
    tempc = pos_c + move(2);

    if tempr > 0 & tempr < row + 1 & tempc > 0 & tempc < column + 1
        if template(tempr,tempc) == 0
            ifcanmove = 1;
        end
    end

    if ifcanmove == 1
        pos_r = pos_r + move(1);
        pos_c = pos_c + move(2);
        template(pos_r,pos_c) = count;
        count = count + 1;
    else
        if pos_c < column & template(pos_r,pos_c + 1) == 0
            move = [0 1];

        elseif pos_r < row & template(pos_r + 1,pos_c) == 0
            move = [1 0];

        elseif pos_c > 1 & template(pos_r,pos_c - 1) == 0
            move = [0 -1];

        elseif pos_r > 1 & template(pos_r - 1,pos_c) == 0
            move = [-1 0];

        else
        end
    end

    index = template == 0;
    judge = sum(sum(index));
end
