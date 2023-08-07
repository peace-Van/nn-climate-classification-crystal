function [clim_img, centroids, res] = get_clim_map(net, res, ds, model, veg_names, colormap_, clim_names)
    N = length(res);
    num_clusters = size(model.new_centroid, 1);
    num_vegs = length(veg_names);

    features = activations(net, ds, 'concat', 'OutputAs', 'rows', 'MiniBatchSize', ds.ReadSize);
    vegs = predict(net, ds, 'MiniBatchSize', ds.ReadSize);

    pca_features = (features - model.mu) * model.coeff;
    num_features = size(model.new_centroid, 2);
    pca_features = pca_features(:, 1:num_features);
    Y = knnsearch(model.new_centroid, pca_features);

    clim_img = NaN(300, 720);
    pred_vegs = NaN(N, 1);
    true_vegs = NaN(N, 1);
    tveg_img = NaN(300, 720);
    pveg_img = NaN(300, 720);
    for i = 1:N
        res(i).pca_features = pca_features(i, 1:3);
        idx = res(i).indices;
        res(i).clim = Y(i);
        clim_img(idx(1), idx(2)) = res(i).clim;
        [~, res(i).pred_veg] = max(vegs(i, :));
        if ~isnan(res(i).veg)
           pred_vegs(i) = res(i).pred_veg;
           true_vegs(i) = res(i).veg;
        end
        pveg_img(idx(1), idx(2)) = res(i).pred_veg;
        tveg_img(idx(1), idx(2)) = res(i).veg;
    end

    pred_vegs = rmmissing(categorical(pred_vegs, 1:num_vegs, veg_names));
    true_vegs = rmmissing(categorical(true_vegs, 1:num_vegs, veg_names));
    cm = confusionchart(true_vegs, pred_vegs, 'ColumnSummary', 'column-normalized', 'RowSummary', 'row-normalized');
    kappa(cm.NormalizedValues)

    pveg_img(isnan(pveg_img)) = 0;
    pveg_img = pveg_img + 1;
    tveg_img(isnan(tveg_img)) = 0;
    tveg_img = tveg_img + 1;
    clim_img(isnan(clim_img)) = 0;
    clim_img = clim_img + 1;
    
    figure; imshow(pveg_img, turbo(num_vegs+1));
    figure; imshow(tveg_img, turbo(num_vegs+1));
    figure; imshow(clim_img, colormap_);
    imlegend(colormap_(2:end, :), clim_names(2:end), 13)

    centroids_idx = knnsearch(pca_features, model.new_centroid);
    centroids = zeros(num_clusters, 2);
    for i = 1:num_clusters
        centroids(i, :) = res(centroids_idx(i)).indices;
    end
end