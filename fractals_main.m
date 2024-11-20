disp("-----");
clear;

% these aren't always set, so define them here
length_line = 1;
length_scale = 1;

%%%%%%%%%%%%%%%%%%%%%
%{
Examples:

1)
axiom = "F+F+F+F";
grammar = {"F -> F+F-F-FF+F+F-F"};
angle_delta = 90;
iterations = 5;

2)
axiom = "F+F+F+F";
grammar = {"F -> FF+F-F+F+FF"};
angle_delta = 90;
iterations = 5;

3) BRANCH:
axiom = "F";
grammar = {"F -> FF+[+F-F-F]-[-F+F+F]"};
angle_delta = 22.5;
iterations = 5;

4)
axiom = "VZFFF";
grammar = {"V -> [+++W][---W]YV", "W -> +X[-W]Z", "X -> -W[+X]Z", "Y -> YZ", "Z -> [-FFF][+FFF]F"};
angle_delta = 20;
iterations = 10;

5) test for > <
axiom = "a"
grammar = {'F -> >F<', 'a -> F[+x]Fb', 'b -> F[-y]Fa', 'x -> a', 'y -> b'}
angle_delta = 45
iterations = 5

axiom = "a"
grammar = {'F -> >F<', 'a -> F[+x]Fb', 'b -> F[-y]Fa', 'x -> a', 'y -> b'}
angle_delta = 45
iterations = 5

--------------------------

axiom = 
grammar = 
angle_delta = 
iterations = 

%}

axiom = "a";
grammar = {'F -> >F<', 'a -> F[+x]Fb', 'b -> F[-y]Fa', 'x -> a', 'y -> b'};
angle_delta = 45;
iterations = 15;
length_scale = 1.36;

%%%%%%%%%%%%%%%%%%%%%

% constants
line_width = 0.2; % width of the plotted lines
origin = [5,5]; % the starting point of the plot
full_rotation = 360; % in case of change to radians idk
starting_angle = 0;
colour_main = 'black';
gram_chars = {}; % these will be populated when grammar is formatted
gram_rules = {};

% variables
curr_angle = starting_angle; % angle where 0 is right/along the x axis
curr_pos = origin;
x_trail = [curr_pos(1)]; % initialise w the starting position
y_trail = [curr_pos(2)];
x_all = [curr_pos(1)];
y_all = [curr_pos(2)];
colours_ptr = 1;

% stack
stack = [];

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

    % split into LHS and RHS, on "->"
    parts = split(r, "->");
    if size(parts,1) ~= 2
        error("rule found with no or multiple '->'");
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
    for n = 1:length(temp1)
        if (ismember(temp1(n),gram_chars)) % if the char read is a char in the grammar
            gram_index = find(strcmp(temp1(n), gram_chars));
            temp2 = [temp2, gram_rules{gram_index}]; % replace all F with the full F->..
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
        [x,y,x_trail,y_trail] = move(curr_pos, curr_angle, length_line, x_trail, y_trail);
        curr_pos = [x,y];
    elseif c == '['
        stack = push(stack, curr_pos, curr_angle);
    elseif c == ']'
        [stack, curr_pos, curr_angle] = pop(stack);
        plot(x_trail, y_trail, 'LineWidth', line_width, 'Color', colour_main);

        x_all = [x_all, x_trail]; y_all = [y_all, y_trail];
        x_trail = [curr_pos(1)]; y_trail = [curr_pos(2)];
    elseif c == '<'
        length_line = length_line / length_scale;
    elseif c == '>'
        length_line = length_line * length_scale;
    elseif ismember(c, gram_chars)
        % this is ok - just ignore - no drawing instructions from these
    else
        disp(c);
        error("unexpected character in string");
    end
end

%%%%%%%%%%%%%%%%%%%%%

% if there's no push/pop then the whole thing will just be drawn at this
% point
plot(x_trail, y_trail, 'LineWidth', line_width, 'Color', colour_main);

% some formating
xticks([]);
yticks([]);
grid off;
axis off;
axis equal;

% Add some padding (e.g., 10% of the range)
x_padding = 0.1 * (max(x_all) - min(x_all));
y_padding = 0.1 * (max(y_all) - min(y_all));

% Set axis limits with padding
%axis([min(x_all) - x_padding, max(x_all) + x_padding, min(y_all) - y_padding, max(y_all) + y_padding]);

% export graphics
disp("Exporting...");
exportgraphics(gcf, 'temp.png', 'Resolution', 512);
disp("Finished exporting!");

hold off;

%%%%%%%%%%%%%%%%%%%%%