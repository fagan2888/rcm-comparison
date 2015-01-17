function string = floatsToString(floats)
    % Converts a vector of floats to a string.
    string = num2str(floats, '%.4f_');
    string = string(1:end-1); % Getting rid of the trailing underscore.
end
