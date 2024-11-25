disp("-----");
clear;

% constants that might be overwritten
length_line = 1;
length_scale = 1;
line_width = 0.2; % width of the plotted lines
colour_main = 'black';
colours = {'red','yellow','green','blue'};

%{

%%%%%%%%%%%%%%%%%%%%%

EXAMPLE COLOURS:

% blue -> pink
colours = get_gradient('#7bc2db','#f518ed',10, "exp");

% green -> blue
colours = get_gradient('#338811','#44DDFF',10);



%%%%%%%%%%%%%%%%%%%%%

EXAMPLE GRAMMARS:

% 1) snowflake
axiom = "F+F+F+F";
grammar = {"F -> F+F-F-FF+F+F-F"};
angle_delta = 90;
iterations = 5;

% 2) bricks
axiom = "F+F+F+F";
grammar = {"F -> FF+F-F+F+FF"};
angle_delta = 90;
iterations = 5;

% 3) branch
axiom = "F";
grammar = {"F -> FF+[+F-F-F]-[-F+F+F]"};
angle_delta = 22.5;
iterations = 5;

% 4) nicer branch
axiom = "VZFFF";
grammar = {"V -> [+++W][---W]YV", "W -> +X[-W]Z", "X -> -W[+X]Z", "Y -> YZ", "Z -> [-FFF][+FFF]F"};
angle_delta = 20;
iterations = 10;

% 5) test for > <
axiom = "a";
grammar = {'F -> >F<', 'a -> F[+x]Fb', 'b -> F[-y]Fa', 'x -> a', 'y -> b'};
angle_delta = 45;
iterations = 5;

--------------------------
axiom = 
grammar = 
angle_delta = 
iterations = 
--------------------------

%}

axiom = "F+F+F+F";
grammar = {"F -> F+F-F-FF+F+F-F"};
angle_delta = 90;
iterations = 5;
colours = get_gradient('#338811','#44DDFF',10);
line_width = 0.07; % width of the plotted lines


%%%%%%%%%%%%%%%%%%%%%

% constants
origin = [5,5]; % the starting point of the plot
full_rotation = 360; % in case of change to radians idk
starting_angle = 0;
gram_chars = {}; % these will be populated when grammar is formatted
gram_rules = {};
fwd_char = 'F';

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
chars_are_unique = ( length(unique(gram_chars)) == length(gram_chars) );
if ~chars_are_unique
    error("Error in grammar: found multiple LHS per RHS");
end

stack_gram = 0;
for i=1:length(gram_rules)
    for j=1:length(gram_rules{i})
        c = gram_rules{i}(j);
        if strcmp(c,'[')
            stack_gram = stack_gram + 1;
        elseif strcmp(c,']')
            stack_gram = stack_gram - 1;
            if stack_gram < 0
                error("Error in grammar: unbalanced push/pop brackets");
            end
        end 
    end
    if stack_gram > 0
        error("Error in grammar: unbalanced push/pop brackets");
    end
end

% ## 3) rewrite the axiom [iteration] times to get the string
temp1 = a;
for i=1:iterations

    % write out the string for each iteration up until [iteration]
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

    % now generate and plot [temp1] in a colour
    string = temp1;
    
    % ## 4) pass thru the string and get the coords for plotting
    for c = string
        flag = 0;

        if c == '+'
            % turn right
            curr_angle = mod(curr_angle+angle_delta,full_rotation);
        elseif c == '-'
            % turn left
            curr_angle = mod(curr_angle-angle_delta,full_rotation);
        elseif c == fwd_char
            [x,y,x_trail,y_trail] = move(curr_pos, curr_angle, length_line, x_trail, y_trail);
            curr_pos = [x,y];
        elseif c == '[' 
            stack = push(stack, curr_pos, curr_angle);
        elseif c == ']'
            [stack, curr_pos, curr_angle] = pop(stack);
            plot(x_trail, y_trail, 'LineWidth', line_width, 'Color', colours{colours_ptr});
            x_all = [x_all, x_trail]; y_all = [y_all, y_trail];
            x_trail = [curr_pos(1)]; y_trail = [curr_pos(2)];
            flag = 1;

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

    if ~flag
        x_all = [x_all, x_trail]; y_all = [y_all, y_trail];
    end

    % if there's no push/pop then the whole thing will just be drawn at this
    % point
    colours_ptr = mod(colours_ptr, length(colours)) + 1;
    plot(x_trail, y_trail, 'LineWidth', line_width, 'Color', colours{colours_ptr});
    
    % some formating
    xticks([]);
    yticks([]);
    grid off;
    axis off;
    axis equal;
    
    hold on;
    fprintf("iteration #%d done\n", i);

end

% setup axis sizes
x_max = max(x_all); x_min = min(x_all);
y_max = max(y_all); y_min = min(y_all);

if (x_max - x_min) <= 0
    x_max = x_max + 1;
end

if (y_max - y_min) <= 0
    y_max = y_max + 1;
end

x_padding = 0.1 * (max(x_all) - min(x_all));
y_padding = 0.1 * (max(y_all) - min(y_all));

axis([x_min - x_padding, x_max + x_padding, y_min - y_padding, y_max + y_padding]);

% export the final graph
disp("Exporting...");
exportgraphics(gcf, 'temp.png', 'Resolution', 4196);
disp("Finished exporting!");
