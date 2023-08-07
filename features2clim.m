% load trainedRes or dataset, features
% if somSize is given (like [4 3 2]), then the code does clustering with SOM
% otherwise set k and the code uses k-means
% clim_img is saved as clim and res is saved as trainedRes

function [clim_img, centroids, res] = features2clim(res, features, somSize, k)
    rng('default');
    
    N = length(res);
%     parfor i = 1:N
%         res(i).features = features(i, :);
%     end
    
    if ~isempty(somSize)
        num_clusters = prod(somSize);        
        som = selforgmap(somSize);
        som.plotFcns = {};
        %som.trainParam.epochs = 1000;
        %som.trainParam.show = NaN;
        %som.trainParam.showWindow = false;

        som = train(som, features');

        Y = som(features');

        centroids = som.IW{1, 1};
        clim_img = NaN(300, 720);
        cats = 1:num_clusters;
        for i = 1:N
            idx = res(i).indices;
            cat = cats * Y(:, i);
            res(i).clim = cat;
            clim_img(idx(1), idx(2)) = cat;
        end
        
    else
        num_clusters = k;
        [Y, centroids] = kmeans(features, num_clusters, 'Display', 'iter', ...
             'OnlinePhase', 'on', 'Options', statset('UseParallel', 1));
        % k-medoids and Gaussian Mixture can be even worse than k-means
%         [~, features] = pca(features);
%         gmm = fitgmdist(features, k, 'Options', statset('Display', 'iter'), 'SharedCovariance', true);
%         Y = cluster(gmm, features);
%         centroids = gmm.mu;
        %[Y, centroids] = kmedoids(features, num_clusters, 'Options', statset('UseParallel', 1, 'Display', 'iter'), 'Distance', 'Euclidean');
        clim_img = NaN(300, 720);
        for i = 1:N
            idx = res(i).indices;
            res(i).clim = Y(i);
            clim_img(idx(1), idx(2)) = Y(i);
        end
    end
    
    Z = linkage(centroids, "ward");
    dendrogram(Z, 0)
    centroids_idx = knnsearch(features, centroids);
    cents = zeros(num_clusters, 2);
    for i = 1:num_clusters
        cents(i, :) = res(centroids_idx(i)).indices;
    end
    centroids = [cents centroids];
    
    clim_img(isnan(clim_img)) = 0;
    clim_img = clim_img + 1;
    cm = turbo(num_clusters+1);

    figure;
    imshow(clim_img, cm);
end