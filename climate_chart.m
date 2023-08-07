% climate_chart(gca, res(100), 'Vancouver', 'green', 'lat: xx, lon: xx, elev: xx m');

function climate_chart(ax, res, city, color, subt)
    title(ax, city, 'Color', color);
    subtitle(subt);
    colororder({'red', 'blue'});
    yyaxis(ax, 'left');
    x = 0.5:1:11.5;
    if isfield(res, 'tmn') && isfield(res, 'tmx')
        e = errorbar(x, res.ori(1, :), ...
            res.ori(1, :) - res.tmn, ...
            res.tmx - res.ori(1, :));
    else
        plot(x, res.ori(1, :), '-r.');
    end
    e.Color = 'red';
    ylim([-30 30]);
    yyaxis(ax, 'right');
    pr = bar(x, res.ori(2, :), 'blue');
    pr.FaceAlpha = 0.5;
    hold(ax, 'on');
    pet = bar(x, res.ori(3, :), 'yellow');
    pet.FaceAlpha = 0.5;
    ylim([0 500]);
end

