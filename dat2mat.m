% After running this code, save the generated 'res' as the corresponding mat file like 'pet.mat'

close all; clear; clc;

% PET SHOULD BE SPECIALLY DEALT WITH
data = readmatrix('pet.dat');
res = zeros(360, 720, 122, 12, 'single');
for y = 1:122
    for m = 1:12
        idx = (y - 1) * 12 + m;
        dat = flipud(data((idx-1)*360+1:idx*360, :));
        dat(dat == -999) = nan;
        days = eomday(1900+y, m);
        res(:, :, y, m) = dat * days / 10;
    end
end

% change the file name here
% data = readmatrix('tmx.dat');
% res = zeros(360, 720, 122, 12, 'single');
% for y = 1:122
%     for m = 1:12
%         idx = (y - 1) * 12 + m;
%         dat = flipud(data((idx-1)*360+1:idx*360, :));
%         dat(dat == -999) = nan;
%         res(:, :, y, m) = dat / 10;
%     end
% end
