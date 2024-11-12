function [stack_returned, curr_pos, curr_angle] = pop(stack)
    %these push and pop functions should probably be moved into a stack class

    % error if stack already empty
    if size(stack,1) <= 0
        error("attempt to pop from an empty stack");
    end

    curr_pos = [stack(end,1), stack(end,2)];
    curr_angle = stack(end,3);
    stack_returned = stack(1:end-1, :); % remove final item

end