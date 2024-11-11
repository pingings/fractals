disp("-----");
clear;

%%%%%%%%%%%%%%%%%%%%%

% ## constants
origin = [5,5]; % the starting point of the plot
full_rotation = 360; % in case of change to radians idk
starting_angle = 0;

% variables
curr_angle = starting_angle; % angle where 0 is right/along the x axis
curr_pos = origin;
x_trail = [curr_pos(1)]; % initialise w the starting position
y_trail = [curr_pos(2)];

% ## inputs
axiom = "F+F+F+F";
grammar = "F+F-F-FF+F+F-F";
angle_delta = 90; % in deg; e.g. 90 means +/- will be right angle turns
length = 1; % e.g. 1 means each F is 1 unit length
iterations = 0;

%%%%%%%%%%%%%%%%%%%%%

% ## 1) grammar into list
g = char(grammar);
g = g(~isspace(g));

% ## 2) expand the axiom by the specified number of iterations
% TODO

% ## 3) plot the axiom
% first pass - syntax check
for c = g
    disp(c);
end

% second pass - get coords
for c = g
    if c == '+'
        % turn right
        curr_angle = mod(curr_angle+angle_delta,full_rotation)
    elseif c == '-'
        % turn left
        curr_angle = mod(curr_angle-angle_delta,full_rotation)
    elseif c == 'F' % TODO don't hardcode the char here
        [x,y,x_trail,y_trail] = move(curr_pos, curr_angle, length, x_trail, y_trail);
        curr_pos = [x,y];     
    end
end

%%%%%%%%%%%%%%%%%%%%%

% setup the canvas
x_min = 0;
x_max = 10;
y_min = 0;
y_max = 10;
axis([x_min x_max y_min y_max]);
hold on; % Keep the plot active for further drawing

% define each point on the trail
plot(x_trail, y_trail, 'LineWidth', 1, 'Color', 'black'); % 'LineWidth' and 'Color' are optional

% this is a separate line
%x_coords = [6,8];
%y_coords = [5,3];
%plot(x_coords, y_coords, 'LineWidth', 1, 'Color', 'black'); % 'LineWidth' and 'Color' are optional

% some formating
grid off;
axis equal;
hold off;