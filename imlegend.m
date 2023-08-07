function imlegend(cm, labels, num_cols)
    n = length(labels);
    entries = cell(n, 1);
    t = sortrows([labels cm]);
    cm_ = double(t(:, 2:4));
    labels_ = t(:, 1);
    hold on;
    for i = 1:n
        entries{i} = scatter([], [], 1, cm_(i, :), 's', 'filled', 'DisplayName', labels_(i));
    end
    hold off;
    legend([entries{:}], labels_, 'Location', 'southoutside', 'Orientation', 'horizontal', 'NumColumns', num_cols);
end