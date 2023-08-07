% helper function

function chart(climatology, lat, lon, color, clim_name, veg_name, kp, capture, work_dir)
    url = sprintf('https://nominatim.openstreetmap.org/reverse?format=json&lat=%f&lon=%f&zoom=8', lat, lon);
    city = "";
    try
        city = webread(url).display_name;
    catch
    end
    city = {city, sprintf('(%s, %s, Köppen: %s)', clim_name, veg_name, kp)};
    subt = sprintf('lat: %.2f, lon: %.2f, elev: %.0f m', lat, lon, climatology.elev);
    
    if capture
        fig = figure('visible', 'off'); ax = axes(fig);
        climate_chart(ax, climatology, city, color, subt);
        exportgraphics(fig, append(work_dir, clim_name, '.png'), 'Resolution', 900);
    else
        fig = figure; ax = axes(fig);
        climate_chart(ax, climatology, city, color, subt);
    end
end