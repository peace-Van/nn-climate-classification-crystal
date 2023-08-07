function ds = res2datastore(res, train, batch_size)
    c = struct2cell(res)';
    c = c(:, 2:3);
    if train
        to_del = [];
        for i = 1:length(c)
            if isnan(sum(c{i, 1}, 'all')) || isnan(sum(c{i, 2}, 'all')) % remove invalid entries
                to_del = [to_del i];
            end
        end
        c(to_del, :) = [];
    end
    
    fprintf('Number of valid observations: %d\n', size(c, 1))
    ds = arrayDatastore(c, 'ReadSize', batch_size, 'OutputType', 'same');
end