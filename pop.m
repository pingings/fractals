function stack_returned = pop(stack)
    %these push and pop functions should probably be moved into a stack class

    % error if stack already empty
    if size(stack,1) <= 0
        error("attempt to pop from an empty stack");
    end

    stack_returned = stack(1:end-1, :); % remove final item

end