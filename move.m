function [x, y, x_all, y_all] = move(curr_pos, angle, distance, x_all, y_all, ptr_all)

    % given a currentPosition, moves units in angle and returns new position
    % e.g. move([5,5], 90, 1) returns [5,4]
    % also keeps track of previous positions

    angleRad = deg2rad(angle+90);
    deltaX = distance * cos(angleRad);
    deltaY = distance * sin(angleRad);

    x = curr_pos(1) + deltaX;
    y = curr_pos(2) + deltaY;

    x_all{ptr_all} = [x_all{ptr_all}, x];
    y_all{ptr_all} = [y_all{ptr_all}, y];

end