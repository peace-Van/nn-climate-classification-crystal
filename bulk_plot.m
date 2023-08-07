% load centroids, trainedRes, colormap, clim, clim_names, veg_names

function bulk_plot(centroids, res, cm, clim_img, clim_names, veg_names, work_dir)
    R = georefcells([-60 90], [-180 180], [300 720], 'ColumnsStartFrom', 'north');
    close all;
    
    climatologies = get_climatologies(res);
    I = clim_img;
    centers = geopoint(intrinsicYToLatitude(R, centroids(:, 1)), intrinsicXToLongitude(R, centroids(:, 2)));
    num_categories = length(centers);

    axm = axesm('pcarree');
    set(gcf, 'WindowState', 'maximized');
    geoshow(axm, I, cm, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    for i = 2:num_categories+1
        color = [1 1 1] - cm(i, :);
        textm(centers.Latitude(i-1), centers.Longitude(i-1), clim_names{i}, 'Color', color, 'FontSize', 8);
        geoshow(axm, centers(i-1), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
    end
    imlegend(cm(2:end, :), clim_names(2:end), 13);

    drawnow;
    exportgraphics(axm, append(work_dir, 'xglobe.png'), 'Resolution', 900);
    close all;
    
    for i = 2:num_categories+1
        %disp(i); disp(clim_names{i});
        res = climatologies{centroids(i-1, 1), centroids(i-1, 2)};
        chart(res, ...
            centers.Latitude(i-1), centers.Longitude(i-1), cm(i, :), clim_names{i}, ...
            veg_names(res.veg), res.koppen, true, work_dir);
        close all;
    end
    
    for i = 1:num_categories
        filter_show(R, clim_names{i+1}, i, centroids(i, 1:2), I, cm, work_dir);
        % Below code doesn't work
        % Weird, it has to be an outside function
%         axm = axesm('pcarree');
%         %set(gcf, 'Visible', 'off');
%         cm = turbo(num_categories);
%         if cat > 1
%             cm(2:cat, :) = ones(cat - 1, 3);
%         end
%         cm(cat+2:end, :) = ones(num_categories - cat - 1, 3);
%         geoshow(axm, uint8(I), cm, R);
%         bordersm('countries', 'k');
%         geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
%         color = [1 1 1] - cm(cat+1, :);
%         textm(centroids.Latitude(cat+1), centroids.Longitude(cat+1), sprintf('%d', cat), 'Color', color, 'FontSize', 8);
%         geoshow(axm, centroids(cat+1), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
%         set(gcf, 'WindowState', 'maximized');
%         exportgraphics(gcf, append(work_dir, sprintf('%d_.png', cat)), 'Resolution', 300);
%         close all;
    end
    
    for i = 1:num_categories
        name = clim_names{i+1};
        back = imread(append(work_dir, sprintf('%s_.png', name)));
        front = imread(append(work_dir, sprintf('%s.png', name)));
        front = imresize(front, 0.5);
        height_back = size(back, 1);
        % width_back = size(back, 2);
        height_front = size(front, 1);
        width_front = size(front, 2);
        back(height_back - height_front + 1:end, 1:width_front, :) = front;
        %delete(append(work_dir, sprintf('%s_.png', name)));
        %delete(append(work_dir, sprintf('%s.png', name)));
        imwrite(back, append(work_dir, sprintf('%s__.png', name)));
    end
end


