% This code starts an interactive map for users to click on, and it
% will show the climate chart of the clicked place

close all; clear; clc;

a = 300; b = 720;
R = georefcells([-60 90], [-180 180], [a b], 'ColumnsStartFrom', 'north');
load('veg_names.mat');

cd clim533_merged_5.2\
load('clim_names.mat');
load('colormap.mat');
cd 1991-2020\
load('centroids.mat');
load('clim.mat');
load('trainedRes.mat');
cd ..\..\

climatologies = get_climatologies(res);

I = clim_img;
centers = geopoint(intrinsicYToLatitude(R, centroids(:, 1)), intrinsicXToLongitude(R, centroids(:, 2)));
num_categories = length(centers);

axm = axesm('pcarree');
geoshow(axm, I, cm, R);
bordersm('countries', 'k');
geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');

for i = 2:num_categories+1
   color = [1 1 1] - cm(i, :);
   textm(centers.Latitude(i-1), centers.Longitude(i-1), clim_names{i}, 'Color', color, 'FontSize', 8);  %%
   geoshow(axm, centers(i-1), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
end

imlegend(cm(2:end, :), clim_names(2:end), 13);

set(gcf, 'WindowState', 'maximized');

% These are used for map interaction, not used in bulk processing
h = findobj(axm, 'HitTest', 'on');
for i = 1:length(h)
    set(h(i, 1), 'HitTest', 'off');
end
set(axm, 'HitTest', 'on');
set(axm, 'ButtonDownFcn', {@my_callback, R, climatologies, cm, clim_names, veg_names});

ipt = "";
while true
    ipt = input('Enter the name of a place to query: ', 's');
    if ipt == "exit"
        break
    end
    url = sprintf('https://nominatim.openstreetmap.org/search?q=%s&format=json', ipt);
    try
        info = webread(url);
        if iscell(info)
            info = info{1};
        elseif isstruct(info)
            info = info(1);
        end
        lat = str2double(info.lat); lon = str2double(info.lon);
        x = round(latitudeToIntrinsicY(R, lat));
        y = round(longitudeToIntrinsicX(R, lon));
        i = I(x, y);
        color = [1 1 1] - cm(i, :);
        gcm = axm;
        textm(lat, lon, ipt, 'Color', color, 'FontSize', 8);
        geoshow(axm, geopoint(lat, lon), 'Marker', 'square', 'MarkerEdgeColor', color, 'MarkerSize', 6);
        climatology = climatologies{x, y};
        city = {info.display_name, sprintf('(%s, %s, Köppen: %s)', clim_names{i}, veg_names(climatology.veg), climatology.koppen)};
        fig = figure; ax = axes(fig);
        subt = sprintf('lat: %.2f, lon: %.2f, elev: %.0f m', lat, lon, climatology.elev);
        climate_chart(ax, climatology, city, cm(i, :), subt);
    catch
        disp('Not Found or Network Error')
    end
end

function my_callback(~, ~, R, climatologies, cm, clim_names, veg_names)
    pt = gcpmap;
    lat = pt(1, 1); x = round(latitudeToIntrinsicY(R, lat));
    lon = pt(1, 2); y = round(longitudeToIntrinsicX(R, lon));
    res = climatologies{x, y};
    if ~isempty(res)
        chart(res, lat, lon, cm(res.clim+1, :), clim_names{res.clim+1}, veg_names(res.veg), res.koppen, false, '');
    end
end
