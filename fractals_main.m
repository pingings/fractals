disp("-----");
clear;

%%%%%%%%%%%%%%%%%%%%%
%{
Examples:

axiom = "F+F+F+F";
grammar = "F+F-F-FF+F+F-F";
angle_delta = 90;
iterations = 5;

axiom = "F+F+F+F";
grammar = "FF+F-F+F+FF";
angle_delta = 90;
iterations = 5;

BRANCH:
axiom = "F";
grammar = "FF+[+F-F-F]-[-F+F+F]";
angle_delta = 22.5;
iterations = 5;

%}
%%%%%%%%%%%%%%%%%%%%%

% constants
origin = [5,5]; % the starting point of the plot
full_rotation = 360; % in case of change to radians idk
starting_angle = 0;
colours = {'red','yellow','green','blue'};
colour_main = 'black';

% variables
curr_angle = starting_angle; % angle where 0 is right/along the x axis
curr_pos = origin;
x_trail = [curr_pos(1)]; % initialise w the starting position
y_trail = [curr_pos(2)];
colours_ptr = 1;

% stack
stack = [];

% inputs
axiom = "F+F+F+F";
grammar = "F+F-F-FF+F+F-F";
angle_delta = 90;
iterations = 5;
length = 1; % e.g. 1 means each F is 1 unit length

%%%%%%%%%%%%%%%%%%%%%

% setup the canvas
x_min = 0;
x_max = 100;
y_min = 0;
y_max = 100;
axis([x_min x_max y_min y_max]);
hold on; % Keep the plot active for further drawing

%%%%%%%%%%%%%%%%%%%%%

% ## 1) format the axiom and grammar into list; remove whitespace
g = char(grammar);
g = g(~isspace(g));
a = char(axiom);
a = a(~isspace(a));

% ## 2) check syntax
% TODO finish this - check balanced push/pop [/]; 
for c = g
    %disp(c);
end

% ## 2) expand the axiom by one iteration into the string, using the gramr
temp1 = a;
temp2 = [];
for i=1:iterations
    temp2 = []; % copy the prev output of this
    for c=temp1
        if (c=='F') % TODO don't hardcode the F
            temp2 = [temp2, g]; % replace all F with the full F-->..
        else
            temp2 = [temp2, c];
        end
    end
    temp1 = temp2; % copy over ready to clear temp2 again
end
string = temp1;

% ## 3) pass thru the final string and get the coords for plotting
for c = string
    if c == '+'
        % turn right
        curr_angle = mod(curr_angle+angle_delta,full_rotation);
    elseif c == '-'
        % turn left
        curr_angle = mod(curr_angle-angle_delta,full_rotation);
    elseif c == 'F' % TODO don't hardcode the char here
        [x,y,x_trail,y_trail] = move(curr_pos, curr_angle, length, x_trail, y_trail);
        curr_pos = [x,y];     
    elseif c == '['
        stack = push(stack, curr_pos, curr_angle);
    elseif c == ']'
        [stack, curr_pos, curr_angle] = pop(stack);
        
        next_colour = colours{colours_ptr};
        plot(x_trail, y_trail, 'LineWidth', 1, 'Color', next_colour);
        colours_ptr = 1+mod(colours_ptr,size(colours,2));

        x_trail = [curr_pos(1)]; y_trail = [curr_pos(2)];
    else
        error("unexpected character in string");
    end
end

%%%%%%%%%%%%%%%%%%%%%

% if there's no push/pop then the whole thing will just be drawn at this
% point
plot(x_trail, y_trail, 'LineWidth', 1, 'Color', colour_main);

% this is a separate line
%x_coords = [6,8];
%y_coords = [5,3];
%plot(x_coords, y_coords, 'LineWidth', 1, 'Color', 'black'); % 'LineWidth' and 'Color' are optional

% some formating
grid off;
axis equal;
hold off;