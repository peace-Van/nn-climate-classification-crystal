close all; clear; clc;

%% parameters

first_year = 2001;
last_year = 2021;
som_size = [5 3 3];
N = 66501;
model = "som";
k = 20;
T = 5.2;    % 5.2 ~ 5.5
% labels = ["111-1", "211-2", "311-3", ...
%     "121-4", "221-5", "321-6", ...
%     "112-7", "212-8", "312-9", ...
%     "122-10", "222-11", "322-12"];
labels = ["111-1", "211-2", "311-3", "411-4", "511-5", ...
    "121-6", "221-7", "321-8", "421-9", "521-10", ...
    "131-11", "231-12", "331-13", "431-14", "531-15", ...
    "112-16", "212-17", "312-18", "412-19", "512-20", ...
    "122-21", "222-22", "322-23", "422-24", "522-25", ...
    "132-26", "232-27", "332-28", "432-29", "532-30", ...
    "113-31", "213-32", "313-33", "413-34", "513-35", ...
    "123-36", "223-37", "323-38", "423-39", "523-40", ...
    "133-41", "233-42", "333-43", "433-44", "533-45"];

%% prepare datastore

fprintf('Preparing datastore...\n')
t = {};
for yr = first_year:last_year
    load(sprintf('datastore_%d.mat', yr));
    t = [t; readall(ds)];
end
ds_predict = arrayDatastore(t, ReadSize=256, OutputType='same');

%% calculate features and pca

fprintf('Calculating features and PCA...\n')
load('trainedNet.mat');
features = activations(net, ds_predict, 'concat', 'OutputAs', 'rows');
[coeff, pca_features, vars, ~, expl, mu] = pca(features);
num_features = find(cumsum(expl) >= 90, 1);
pca_features = pca_features(:, 1:num_features);

%% train som

if model == "som"
    fprintf('Training SOM...\n')
    %pca_features = reshape(pca_features, N, last_year - first_year + 1, []);
    %pca_features = squeeze(mean(pca_features, 2));
    
    som = selforgmap(som_size, 100);
    som.plotFcns = {};
    %som.trainParam.epochs = 200;
    som = train(som, pca_features');
    
    Y = vec2ind(som(pca_features'));

    centroids = som.IW{1, 1};
    Z = linkage(centroids, "ward");
    figure; dendrogram(Z, 0, Labels=labels)

elseif model == "kmeans"
    fprintf('Training k-means...\n')
    [Y, centroids] = kmeans(pca_features, k, 'Display', 'iter', ...
             'OnlinePhase', 'off', 'MaxIter', 200, 'Replicates', 8, 'Options', statset('UseParallel', 1));

    Z = linkage(centroids, "ward");
    figure; dendrogram(Z, 0)
end

w = groupcounts(Y') / length(Y);
mst = my_minspantree(centroids, ones(k, 1));
mst.Edges.Weight = -1 ./ mst.Edges.Weight;
figure; p = plot(mst);      %, 'NodeLabel', labels);
layout(p, 'force', 'WeightEffect', 'direct')

[idx, mst, G] = crystalcluster(double(centroids), [], T, 'backtrack', inf);
mst.Edges.Weight = -1 ./ mst.Edges.Weight;
figure; p = plot(mst, 'NodeLabel', labels);
layout(p, 'force', 'WeightEffect', 'direct')

num_classes = max(idx);
new_centroid = zeros(num_classes, num_features, 'single');
for i = 1:num_classes
    new_centroid(i, :) = sum(w(idx == i) .* centroids(idx == i, :), 1) ./ sum(w(idx == i));
end

load(sprintf('dataset_%d.mat', last_year))
YY = Y(end-N+1:end);
clim_img = NaN(300, 720);
for i = 1:N
    idx = res(i).indices;
    clim_img(idx(1), idx(2)) = YY(i);
end
clim_img(isnan(clim_img)) = 0;
clim_img = clim_img + 1;
figure; imshow(clim_img, turbo(k+1));

%% save model

clim_model = struct('coeff', coeff, 'mu', mu, 'expl', expl, 'sigma', sqrt(vars), ...
    'centroid', centroids, 'class_weight', w, 'class_label', labels, ...
    'new_centroid', new_centroid, 'merge_idx', idx);
save("clim_model_533_merged_5.2.mat", "clim_model");
fprintf('All done.\n')
