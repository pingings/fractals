function [colours] = get_gradient(hex1,hex2,step)
    
    % maps e.g. '#FF00AA' -> [1 0 0.667]
    rgb1 = hex2rgb(hex1);
    rgb2 = hex2rgb(hex2);
    
    % e.g. linspace(0.1, 0.4, 4) = [0.1 0.2 0.3 0.4]
    r = linspace(rgb1(1), rgb2(1), step);
    g = linspace(rgb1(2), rgb2(2), step);
    b = linspace(rgb1(3), rgb2(3), step);
    
    % Convert back to hex
    colours = cell(1, step);
    for i = 1:step
        colours{i} = rgb2hex([r(i), g(i), b(i)]);
    end

end