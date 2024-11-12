function stack_returned = push(stack, curr_pos, curr_angle)
    %these push and pop functions should probably be moved into a stack class
    if isempty(stack)
        stack_returned = [curr_pos, curr_angle];
    else
        stack_returned = [stack; [curr_pos, curr_angle]];
    end
end