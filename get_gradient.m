function [colours] = get_gradient(hex1,hex2,step,varargin)
    
    % maps e.g. '#FF00AA' -> [1 0 0.667]
    rgb1 = hex2rgb(hex1);
    rgb2 = hex2rgb(hex2);

    % get gradient function
    t = linspace(0, 1, step);

    % if gradient function passed,
    if (length(varargin) >= 1)
        grad_func = varargin{1};

        % apply function to linspace
        if strcmp(grad_func, "exp")
            t = t.^2;
        elseif strcmp(grad_func, "exp2")
            % TODO ...
        end

    end

    gradient = (1 - t') .* rgb1 + t' .* rgb2;

    % init empty 1D cell array for colours
    colours = cell(step,1);
    for i = 1:step
        colours{i} =  rgb2hex(gradient(i, :));
    end

end