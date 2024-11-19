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
gram_chars = {}; % these will be populated when grammar is formatted
gram_rules = {};

% variables
curr_angle = starting_angle; % angle where 0 is right/along the x axis
curr_pos = origin;
x_all = {curr_pos(1)};
y_all = {curr_pos(2)};
ptr_all = 1; % ptr for length of x_all and y_all (always same length)
colours_ptr = 1;

% stack
stack = [];

% inputs
axiom = "X";
grammar = {"F --> FF", "X --> F-[[X]+X]+F[+FX]-X"};
angle_delta = 22.5;
iterations = 6;
unit_length = 1; % e.g. 1 means each F is 1 unit length

%%%%%%%%%%%%%%%%%%%%%

% setup the canvas
x_min = 0;
x_max = 1000;
y_min = 0;
y_max = 1000;
axis([x_min x_max y_min y_max]);
hold on; % Keep the plot active for further drawing

%%%%%%%%%%%%%%%%%%%%%

% ## 1) format and rewrite
for i = 1:size(grammar,2)

    % rewrite axiom as char array
    a = char(axiom);
    a = a(~isspace(a));

    % for each rule, first convert to char array
    r = grammar{i};
    r = char(r);
    r = r(~isspace(r));

    % split into LHS and RHS, on "-->"
    parts = split(r, "-->");
    if size(parts,1) ~= 2
        error("rule found with no or multiple '-->'");
    end
    gram_chars = [gram_chars; parts(1)];
    gram_rules = [gram_rules; parts(2)];
   
end


% ## 2) check syntax
% TODO finish this - check balanced push/pop [/]; not multiple rules per
% LHS; 
%for c = g
    %disp(c);
%end


% ## 3) rewrite the axiom [iteration] times to get the string
temp1 = a;
for i=1:iterations
    temp2 = [];
    for n = 1:length(temp1):-1:1
        if (ismember(temp1(n),gram_chars)) % if the char read is a char in the grammar
            gram_index = find(strcmp(temp1(n), gram_chars));
            temp2 = [temp2, gram_rules{gram_index}]; % replace all F with the full F-->..
        else
            temp2 = [temp2, temp1(n)]; 
        end
    end
    temp1 = temp2; % copy over ready to clear temp2 again
end
string = temp1;


% ## 4) pass thru the final string and get the coords for plotting
for c = string
    if c == '+'
        % turn right
        curr_angle = mod(curr_angle+angle_delta,full_rotation);
    elseif c == '-'
        % turn left
        curr_angle = mod(curr_angle-angle_delta,full_rotation);
    elseif c == 'F' % TODO don't hardcode the char here
        [x,y,x_all,y_all] = move(curr_pos, curr_angle, unit_length, x_all, y_all, ptr_all);
        curr_pos = [x,y];     
    elseif c == '['
        stack = push(stack, curr_pos, curr_angle);
    elseif c == ']'
        [stack, curr_pos, curr_angle] = pop(stack);

        % start a new list in x/y_all
        ptr_all = ptr_all + 1;
        x_all{ptr_all} = []; y_all{ptr_all} = [];

    elseif ismember(c, gram_chars)
        % this is ok - just ignore - no drawing instructions from these
    else
        disp(c);
        error("unexpected character in string");
    end
end

%%%%%%%%%%%%%%%%%%%%%

% plot all the arrays of coords
for i = 1:length(x_all)
    next_colour = colours{colours_ptr};
    plot(x_all{i}, y_all{i}, 'LineWidth', 1, 'Color', next_colour);
    colours_ptr = 1+mod(colours_ptr,size(colours,2));
end

% some formating
xticks([]);
yticks([]);
grid off;
axis off;
axis equal;

min_x = 0; max_x = 100; min_y = 0; max_y = 100;

% Add some padding (e.g., 10% of the range)
x_padding = 0.1 * (max_x - min_x);
y_padding = 0.1 * (max_y - min_y);

% Set axis limits with padding
axis([min_x - x_padding, x_max + x_padding, min_y - y_padding, max_y + y_padding]);

% export graphics
disp("Exporting...");
exportgraphics(gcf, 'temp.png', 'Resolution', 512);
disp("Finished exporting!");

hold off;

%%%%%%%%%%%%%%%%%%%%%
