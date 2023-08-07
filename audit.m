% This code packs tmp, pre, pet into training set (dataset.mat)

% load('pre.mat'); load('pet.mat'); load('tmp.mat'); load('veg_%d.mat');
% load('tmn.mat'); load('tmx.mat'); load('elev.mat');
% res = audit(91, 30, tmp, pre, pet, tmn, tmx, veg, elev);  % 1991 - 2020 normals

function res = audit(yr, yrs, tmp, pre, pet, tmn, tmx, veg, elev)
    indices = {};
    ori = {};
    vegs = {};
    vegg = {};
    elevs = {};
    tmns = {};
    tmxs = {};
    kps = {};
    for i = 1:360
        for j = 1:720
            tmp_ = reshape(mean(tmp(i, j, yr:yr+yrs-1, :), 3), 1, 12);
            pre_ = reshape(mean(pre(i, j, yr:yr+yrs-1, :), 3), 1, 12);
            pet_ = reshape(mean(pet(i, j, yr:yr+yrs-1, :), 3), 1, 12);
            pic = [tmp_; pre_; pet_];
            tmn_ = reshape(mean(tmn(i, j, yr:yr+yrs-1, :), 3), 1, 12);
            tmx_ = reshape(mean(tmx(i, j, yr:yr+yrs-1, :), 3), 1, 12);
            veg_ = reshape(veg(i, j, :), 1, []);
            if ~isnan(sum(pic, 'all')) %&& ~isnan(sum(veg_))
                indices{end+1} = [i, j];
                ori{end+1} = pic;
                vegs{end+1} = veg_;
                elevs{end+1} = elev(i, j);
                tmns{end+1} = tmn_;
                tmxs{end+1} = tmx_;    
                kps{end+1} = koppen_class(pic);
                if ~isnan(sum(veg_))
                    [~, vegg{end+1}] = max(veg_);
                else
                    vegg{end+1} = NaN;
                end
            end
        end
    end
    res = struct('indices', indices, 'ori', ori, 'vegs', vegs, 'veg', vegg, ...
        'tmn', tmns, 'tmx', tmxs, 'elev', elevs, 'koppen', kps)';
    %save(sprintf("dataset_%d.mat", yr + yrs), "res");

end

