% load colormap, trainedNet, clim_model, clim_names, veg_names
% climatology is best to be a struct with ori, tmn, tmx fields
% ori is a 3*12 matrix, rows are tmp, pre, pet from top to bottom
% ori is must-have

function [c, v] = get_clim(climatology, name, cm, net, model, clim_names, veg_names)
    vvv = predict(net, climatology.ori);
    [~, vv] = max(vvv);
    v = veg_names(vv);
    features = activations(net, climatology.ori, 'concat', 'OutputAs', 'rows');

    pca_features = (features - model.mu) * model.coeff;
    num_features = size(model.new_centroid, 2);
    pca_features = pca_features(:, 1:num_features);
    cc = knnsearch(model.new_centroid, pca_features) + 1;

    c = clim_names(cc);
    title = {name, sprintf('%s, vegetation predicted: %s', c, v)};
    color = cm(cc, :);
    fig = figure; ax = axes(fig);
    climate_chart(ax, climatology, title, color, '');
end