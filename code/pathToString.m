function strPath = pathToString(vertices)
    strPath = '';
    for i = 1:length(vertices)
        if vertices(i) == 0
            break;
        end
        strPath = [strPath '-' num2str(vertices(i))];
    end
    strPath = strPath(2:end);
end