function [x, y, x_trail, y_trail] = move(curr_pos, angle, distance, x_trail, y_trail)

    % given a currentPosition, moves units in angle and returns new position
    % e.g. move([5,5], 90, 1) returns [5,4]
    % also keeps track of previous positions

    angleRad = deg2rad(angle);
    deltaX = distance * cos(angleRad);
    deltaY = distance * sin(angleRad);

    x = curr_pos(1) + deltaX;
    y = curr_pos(2) + deltaY;

    x_trail = [x_trail, x];
    y_trail = [y_trail, y];

end