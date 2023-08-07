function climatologies = get_climatologies(res)
    climatologies = cell(300, 720);
    for i = 1:length(res)
        idx = res(i).indices;
        climatologies{idx(1), idx(2)} = res(i);
    end
end