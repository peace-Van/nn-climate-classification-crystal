function filter_show(R, cat, i, centroid, clim_img, cm, work_dir)    
    I = clim_img;
    centroid = geopoint(intrinsicYToLatitude(R, centroid(:, 1)), intrinsicXToLongitude(R, centroid(:, 2)));
    num_categories = max(I, [], 'all');
    
    axm = axesm('pcarree');
    set(gcf, 'WindowState', 'maximized');
%    set(gcf, 'Visible', 'off');
    %cm = turbo(num_categories);
    %cm = [cm(1, :); flipud(cm(2:end, :))];
    cm_ = cm;
    if i > 1
        cm_(2:i, :) = ones(i - 1, 3);
    end
    cm_(i+2:end, :) = ones(num_categories - i - 1, 3);
    geoshow(axm, I, cm_, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    text_color = [1 1 1] - cm_(i+1, :);
    textm(centroid.Latitude, centroid.Longitude, cat, 'Color', text_color, 'FontSize', 8);
    geoshow(axm, centroid, 'Marker', 'diamond', 'MarkerEdgeColor', text_color, 'MarkerSize', 6);
    
    drawnow;
    exportgraphics(gcf, append(work_dir, sprintf('%s_.png', cat)), 'Resolution', 900);
    close all;
end