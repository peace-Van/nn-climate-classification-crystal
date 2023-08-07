close all; clear; clc;

for k = 2001:2021
    fprintf('%d', k)
    tic
    S = hdfinfo(sprintf('veg_%d.hdf', k));
    data = double(hdfread(S.Vgroup.Vgroup(1).SDS(3)));
    
    veg = zeros(360, 720, 14, 'single');
    for i = 1:360
        for j = 1:720
            r = sum(data(10*i-9:10*i, 10*j-9:10*j, :), [1 2]);
            rr = [r(2) r(4) r(3) r(5) r(6) r(7) r(8) r(9) r(10) r(11) r(12) r(13)+r(15) r(16) r(17)];
            veg(i, j, :) = rr / sum(rr);
        end
    end
    save(sprintf('veg_%d.mat', k), 'veg')
    toc
end